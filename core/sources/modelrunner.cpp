#include "modelrunner.h"


ModelRunner::ModelRunner(QObject *parent)
    : QObject{parent},
    isModelLoaded(false),
    m_diseaseName(""),
    m_description(""),
    m_cure(""),
    m_confidence(0.0)
{
    // Constructor
    loadModel();
}

/**
 * @brief ModelRunner::classifyImage
 * @param imagePath
 * @return Inference result as QString
 */

void ModelRunner::classifyImage(const QString &imageDataBase64)
{
    QString filePath;
    if (imageDataBase64.startsWith("data:image")) {
        QByteArray data = QByteArray::fromBase64(imageDataBase64.split(',')[1].toUtf8());
        filePath = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/temp_image.png";
        QFile file(filePath);
        if (!file.open(QIODevice::WriteOnly)) {
            qDebug() << "Failed to write temp file.";
            return ;
        }
        file.write(data);
        file.close();
    } else {
        filePath = imageDataBase64;
    }
    cv::Mat img = cv::imread(filePath.toStdString());
    if (img.empty()) {
        qDebug() <<  "Failed to load image.";
        return;
    }

    auto input = preprocess(img);
    if (!input) {

        qDebug() <<  "Preprocessing failed.";
        return;
    }
    if (!isModelLoaded || !module){
        qDebug() << "Model not loaded.";
        return;
    }

    const auto result = module->forward(std::vector<EValue>{EValue(*input)});
    if (!result.ok()) {
        emit infarenceFaild();
        return;
    }
    const auto& outputTensor = result->at(0).toTensor();
    const float* output = outputTensor.const_data_ptr<float>();
    int numOutputs = outputTensor.numel();

    if (numOutputs != 38) {
        qDebug() <<"Unexpected output size: %1 (expected 38)";
        return;
    }
    qDebug() << "Num elements:" << numOutputs;

    // Softmax: Convert logits to probabilities
    std::vector<float> probs(numOutputs);
    float maxLogit = *std::max_element(output, output + numOutputs);
    float sumExp = 0.0f;
    for (int i = 0; i < numOutputs; ++i) {
        probs[i] = std::exp(output[i] - maxLogit);  // Subtract max for numerical stability
        sumExp += probs[i];
    }
    for (int i = 0; i < numOutputs; ++i) {
        probs[i] /= sumExp;
    }

    // Find top class
    auto maxIt = std::max_element(probs.begin(), probs.end());
    int topClassIdx = std::distance(probs.begin(), maxIt);
    float topConfidence = *maxIt * 100.0f;  // As percentage

    qDebug() << "Top class index:" << topClassIdx << "Confidence:" << topConfidence << "%";

    setDiseaseName(className(topClassIdx));
    setDescription(classDescripion(topClassIdx));
    setCure(classCure(topClassIdx));
    setConfidence(topConfidence);

    emit infarenceFinished();

}
/**
 * @brief ModelRunner::className
 * @param class_id
 * @return diseaseName
 */
QString ModelRunner::className(int class_id)
{
    static QMap<int, QString> class_map = {
        {0, "Apple Scab"},
        {1, "Apple with Black Rot"},
        {2, "Cedar Apple Rust"},
        {3, "Healthy Apple"},
        {4, "Healthy Blueberry Plant"},
        {5, "Cherry with Powdery Mildew"},
        {6, "Healthy Cherry Plant"},
        {7, "Corn (Maize) with Cercospora and Gray Leaf Spot"},
        {8, "Corn (Maize) with Common Rust"},
        {9, "Corn (Maize) with Northern Leaf Blight"},
        {10, "Healthy Corn (Maize) Plant"},
        {11, "Grape with Black Rot"},
        {12, "Grape with Esca (Black Measles)"},
        {13, "Grape with Isariopsis Leaf Spot"},
        {14, "Healthy Grape Plant"},
        {15, "Orange with Citrus Greening"},
        {16, "Peach with Bacterial Spot"},
        {17, "Healthy Peach Plant"},
        {18, "Bell Pepper with Bacterial Spot"},
        {19, "Healthy Bell Pepper Plant"},
        {20, "Potato with Early Blight"},
        {21, "Potato with Late Blight"},
        {22, "Healthy Potato Plant"},
        {23, "Healthy Raspberry Plant"},
        {24, "Healthy Soybean Plant"},
        {25, "Squash with Powdery Mildew"},
        {26, "Strawberry with Leaf Scorch"},
        {27, "Healthy Strawberry Plant"},
        {28, "Tomato with Bacterial Spot"},
        {29, "Tomato with Early Blight"},
        {30, "Tomato with Late Blight"},
        {31, "Tomato with Leaf Mold"},
        {32, "Tomato with Septoria Leaf Spot"},
        {33, "Tomato with Spider Mites or Two-spotted Spider Mite"},
        {34, "Tomato with Target Spot"},
        {35, "Tomato Yellow Leaf Curl Virus"},
        {36, "Tomato Mosaic Virus"},
        {37, "Healthy Tomato Plant"}
    };

    return class_map.value(class_id, QString("Unknown Class %1").arg(class_id));
}
/**
 * @brief ModelRunner::descripion
 * @param class_id
 * @return the description and cause if availe esle just infomation
 */
QString ModelRunner::classDescripion(int class_id)
{
    static QMap<int, QString> description_map = {
        {0, "Apple Scab is a fungal disease caused by Venturia inaequalis. It creates dark, scabby lesions on leaves, fruit, and young shoots."},
        {1, "Black Rot on apples is caused by Botryosphaeria obtusa. It causes concentric dark rings on fruit and cankers on branches."},
        {2, "Cedar Apple Rust is a fungal disease requiring both apple and cedar trees to complete its life cycle. It produces bright orange spots on apple leaves."},
        {3, "This apple is healthy and shows no visible signs of disease."},
        {4, "This blueberry plant appears healthy, with normal leaf color and texture."},
        {5, "Powdery Mildew on cherries is caused by Podosphaera clandestina, leading to white, powdery fungal growth on leaves and fruit."},
        {6, "This cherry plant is healthy and free from visible fungal or bacterial infections."},
        {7, "Cercospora and Gray Leaf Spot on maize are fungal diseases that cause gray or brown spots, reducing photosynthesis."},
        {8, "Common Rust on maize is caused by Puccinia sorghi, forming orange pustules on leaves."},
        {9, "Northern Leaf Blight on maize causes long, gray-green lesions that later turn tan, reducing yield."},
        {10, "This maize plant is healthy and vigorous."},
        {11, "Black Rot on grapes is caused by Guignardia bidwellii, forming circular brown spots on leaves and shriveled black fruit."},
        {12, "Esca (Black Measles) on grapes is a fungal complex causing leaf striping and fruit shriveling."},
        {13, "Isariopsis Leaf Spot causes angular dark spots on grape leaves, leading to early leaf drop."},
        {14, "This grape plant is healthy and disease-free."},
        {15, "Citrus Greening (Huanglongbing) is a bacterial disease spread by psyllids, causing yellow shoots, misshapen fruit, and death of branches."},
        {16, "Bacterial Spot on peaches causes dark, water-soaked lesions on fruit and leaves, leading to defoliation."},
        {17, "This peach plant is healthy with normal foliage and fruit."},
        {18, "Bacterial Spot on peppers causes small, dark, raised lesions on leaves and fruits."},
        {19, "This bell pepper plant is healthy and shows normal growth."},
        {20, "Early Blight on potatoes is caused by Alternaria solani, creating concentric ring lesions on lower leaves."},
        {21, "Late Blight on potatoes is caused by Phytophthora infestans, producing brown patches and white mold growth."},
        {22, "This potato plant is healthy."},
        {23, "This raspberry plant is healthy and free from infection."},
        {24, "This soybean plant is healthy, showing normal leaf color and size."},
        {25, "Powdery Mildew on squash causes white powder-like spots on leaves, reducing yield."},
        {26, "Leaf Scorch on strawberries is caused by Xanthomonas fragariae, leading to reddish-brown leaf edges."},
        {27, "This strawberry plant is healthy and fruiting normally."},
        {28, "Bacterial Spot on tomatoes causes small water-soaked lesions on leaves and fruits."},
        {29, "Early Blight on tomatoes is caused by Alternaria solani, forming target-like spots on older leaves."},
        {30, "Late Blight on tomatoes is caused by Phytophthora infestans, rapidly destroying leaves and fruit."},
        {31, "Leaf Mold on tomatoes is caused by Fulvia fulva, appearing as yellow patches that turn brown."},
        {32, "Septoria Leaf Spot on tomatoes forms numerous small, dark-bordered spots on lower leaves."},
        {33, "Spider Mite damage causes stippling, yellowing, and webbing on leaves."},
        {34, "Target Spot is a fungal disease causing dark circular spots with concentric rings on tomato leaves."},
        {35, "Tomato Yellow Leaf Curl Virus is transmitted by whiteflies, causing curled, yellow leaves and stunted growth."},
        {36, "Tomato Mosaic Virus causes mottled, distorted leaves and reduced fruit size."},
        {37, "This tomato plant is healthy and free from visible infection."}
    };

    return description_map.value(class_id, QString("No description available for class %1").arg(class_id));
}
/**
 * @brief ModelRunner::cure
 * @param class_id
 * @return the cure
 */

QString ModelRunner::classCure(int class_id)
{
    static QMap<int, QString> cure_map = {
        {0, "Use resistant apple varieties, prune infected branches, and apply fungicides like captan or mancozeb during early growth."},
        {1, "Remove mummified fruits and cankers, prune dead wood, and apply fungicides during early fruit development."},
        {2, "Remove nearby cedar hosts or apply fungicides in spring. Use resistant apple varieties."},
        {3, "No action needed. Maintain proper nutrition and watering."},
        {4, "No cure needed. Keep monitoring for any pest or nutrient issues."},
        {5, "Prune infected parts, improve air circulation, and apply sulfur-based fungicides."},
        {6, "Maintain good air circulation and monitor for powdery mildew or aphids."},
        {7, "Rotate crops and apply fungicides with strobilurin or triazole active ingredients."},
        {8, "Plant resistant hybrids and apply fungicides early in the growing season."},
        {9, "Use resistant varieties and ensure proper crop rotation. Apply fungicides if needed."},
        {10, "Keep soil well-drained and fertilize appropriately."},
        {11, "Prune infected areas, remove fallen debris, and apply preventive fungicides."},
        {12, "Remove and destroy infected vines; avoid stress and waterlogging. No complete cure."},
        {13, "Improve air circulation and apply copper-based fungicides as prevention."},
        {14, "Maintain balanced watering and pruning."},
        {15, "No known cure. Remove infected trees and control psyllid populations."},
        {16, "Apply copper-based sprays and use resistant cultivars."},
        {17, "No cure needed; maintain regular monitoring."},
        {18, "Use disease-free seeds, apply copper sprays, and rotate crops."},
        {19, "No cure needed."},
        {20, "Remove infected leaves, rotate crops, and apply chlorothalonil or mancozeb."},
        {21, "Remove infected plants immediately. Apply fungicides preventively and avoid overhead irrigation."},
        {22, "No cure needed."},
        {23, "Maintain clean soil and monitor for mites or leaf spot."},
        {24, "Maintain proper soil health and irrigation."},
        {25, "Use resistant varieties and apply sulfur fungicide early."},
        {26, "Remove infected leaves and improve air flow; apply copper sprays if needed."},
        {27, "No cure needed."},
        {28, "Use copper-based sprays and avoid working with wet foliage."},
        {29, "Remove lower infected leaves and use fungicides containing chlorothalonil."},
        {30, "Destroy infected plants, avoid overhead watering, and apply copper fungicides."},
        {31, "Reduce humidity in greenhouses and use resistant cultivars."},
        {32, "Prune infected leaves and apply chlorothalonil-based fungicides."},
        {33, "Spray neem oil or insecticidal soap; maintain high humidity to reduce mites."},
        {34, "Apply preventive fungicides and improve drainage."},
        {35, "Control whiteflies with yellow traps or neem oil; use resistant varieties."},
        {36, "Remove infected plants and disinfect tools. Avoid tobacco handling near plants."},
        {37, "No cure needed; maintain good growing conditions."}
    };

    return cure_map.value(class_id, QString("No cure or prevention information available for class %1").arg(class_id));
}
/**
 * @brief ModelRunner::confidence
 * @return the infarence confidence
 */
float ModelRunner::confidence() const
{
    return m_confidence;
}
/**
 * @brief ModelRunner::setConfidence
 * @param newConfidence
 */
void ModelRunner::setConfidence(float newConfidence)
{
    if (qFuzzyCompare(m_confidence, newConfidence))
        return;
    m_confidence = newConfidence;
    emit confidenceChanged();
}
/**
 * @brief ModelRunner::cure
 * @return the disease cure
 */
QString ModelRunner::cure() const
{
    return m_cure;
}
/**
 * @brief ModelRunner::setCure
 * @param newCure
 */
void ModelRunner::setCure(const QString &newCure)
{
    if (m_cure == newCure)
        return;
    m_cure = newCure;
    emit cureChanged();
}

/**
 * @brief ModelRunner::description
 * @return the disease description
 */
QString ModelRunner::description() const
{
    return m_description;
}
/**
 * @brief ModelRunner::setDescription
 * @param newDescription
 */
void ModelRunner::setDescription(const QString &newDescription)
{
    if (m_description == newDescription)
        return;
    m_description = newDescription;
    emit descriptionChanged();
}

/**
 * @brief ModelRunner::diseaseName
 * @return the name of the deseasname
 */
QString ModelRunner::diseaseName() const
{
    return m_diseaseName;
}
/**
 * @brief ModelRunner::setDiseaseName
 * @param newDiseaseName
 */
void ModelRunner::setDiseaseName(const QString &newDiseaseName)
{
    if (m_diseaseName == newDiseaseName)
        return;
    m_diseaseName = newDiseaseName;
    emit diseaseNameChanged();
}

/**
 * @brief ModelRunner::loadModel
 * Load the plant classification model (no param in header)
 */
void ModelRunner::loadModel()
{
    QString path = prepareModelFile();
    if (path.isEmpty()) {
        qDebug() << "Model not found!";
        isModelLoaded = false;
        return;
    }
    try {
        // Fix: Use reset for QScopedPointer
        module.reset(new Module(path.toStdString()));
        isModelLoaded = true;
        qDebug() << "Model loaded successfully from:" << path;
    } catch (const std::exception &e) {
        qDebug() << "Failed to load model:" << e.what();
        isModelLoaded = false;
    }
}

/**
 * @brief ModelRunner::preprocess
 * @param img
 * @return Preprocessed TensorPtr (NCHW, normalized)
 */
TensorPtr ModelRunner::preprocess(const cv::Mat &img)
{
    if (img.empty()) {
        qDebug() << "Empty image for preprocess";
        return nullptr;
    }
    cv::Mat resized, normalized;
    cv::resize(img, resized, cv::Size(224, 224));  // Resize to model input
    resized.convertTo(normalized, CV_32FC3, 1.0 / 255.0);  // Normalize [0,1], keep channels

    // Rearrange to NCHW: Split BGR channels and interleave
    std::vector<cv::Mat> channels(3);
    cv::split(normalized, channels);  // channels[0]=B, [1]=G, [2]=R
    std::vector<float> data(1 * 3 * 224 * 224);
    for (int c = 0; c < 3; ++c) {
        // Copy channel to contiguous block (N=1, H=224, W=224)
        memcpy(data.data() + c * 224 * 224, channels[c].data, 224 * 224 * sizeof(float));
    }

    // Use aten::SizesType (int64_t alias)
    std::vector<executorch::aten::SizesType> shape = {1, 3, 224, 224};
    auto tensor = from_blob(
        data.data(),  // Owning buffer (local vector)
        shape,
        executorch::aten::ScalarType::Float  // dtype
        );
    if (!tensor) {
        qDebug() << "Failed to create tensor";
        return nullptr;
    }
    return tensor;
}

/**
 * @brief ModelRunner::matToQImage
 * @param mat
 * @return QImage
 */
QImage ModelRunner::matToQImage(const cv::Mat &mat)
{
    switch (mat.type()) {
    case CV_8UC3: {
        QImage img(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_RGB888);
        return img.rgbSwapped(); // BGR -> RGB
    }
    case CV_8UC4: {
        return QImage(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_ARGB32);
    }
    case CV_8UC1: {
        return QImage(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_Grayscale8);
    }
    default:
        qWarning() << "Unsupported cv::Mat format for conversion:" << mat.type();
        return QImage();
    }
}

/**
 * @brief ModelRunner::qImageToMat
 * @param image
 * @return Mat
 */
cv::Mat ModelRunner::qImageToMat(const QImage &image)
{
    switch (image.format()) {
    case QImage::Format_RGB888: {
        cv::Mat mat(image.height(), image.width(), CV_8UC3,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        cv::Mat matBGR;
        cv::cvtColor(mat, matBGR, cv::COLOR_RGB2BGR);
        return matBGR;
    }
    case QImage::Format_ARGB32:
    case QImage::Format_ARGB32_Premultiplied:
    case QImage::Format_RGB32: {
        cv::Mat mat(image.height(), image.width(), CV_8UC4,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        cv::Mat matBGR;
        cv::cvtColor(mat, matBGR, cv::COLOR_BGRA2BGR); // Drop alpha
        return matBGR;
    }
    case QImage::Format_Grayscale8: {
        cv::Mat mat(image.height(), image.width(), CV_8UC1,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        return mat.clone();
    }
    default:
        qWarning() << "Unsupported QImage format for conversion:" << image.format();
        return cv::Mat();
    }
}

/**
 * @brief ModelRunner::prepareModelFile
 * @return Path to copied .pte model
 */
QString ModelRunner::prepareModelFile()
{
    QString targetPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
    + "/plant_disease_model.pte";

    if (QFile::exists(targetPath)) {
        return targetPath;
    }

#ifdef Q_OS_ANDROID
    QString sourcePath = "assets:/model/plant_disease_model.pte";
#else
    // QString sourcePath = "/home/cassim/Csociety/Qt/OpenCV/OPenCV/plant_disease_model.pte";
#endif
    QDir dir("assets:/model");
    qDebug() << "Files in assets:/model:" << dir.entryList();

    QFile source(sourcePath);
    if (!source.exists()) {
        qDebug() << "Model file not found at:" << sourcePath;
        return {};
    }

    QDir().mkpath(QFileInfo(targetPath).path());
    if (!source.copy(targetPath)) {
        qDebug() << "Failed to copy model to internal storage! Error:" << source.errorString();
        return {};
    }

    qDebug() << "Model copied to:" << targetPath;
    return targetPath;

}

