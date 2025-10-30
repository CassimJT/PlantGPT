#include "modelrunner.h"


ModelRunner::ModelRunner(QObject *parent)
    : QObject{parent},
    isModelLoaded(false)
{
    // Constructor
     loadModel();
}

/**
 * @brief ModelRunner::classifyImage
 * @param imagePath
 * @return Inference result as QString
 */
#include <QFile>
#include <QByteArray>
#include <QBuffer>

#include <vector>
#include <algorithm>  // For std::max_element
#include <cmath>      // For exp, log (but we use exp only)

QString ModelRunner::classifyImage(const QString &imageDataBase64)
{
    QString filePath;
    if (imageDataBase64.startsWith("data:image")) {
        QByteArray data = QByteArray::fromBase64(imageDataBase64.split(',')[1].toUtf8());
        filePath = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/temp_image.png";
        QFile file(filePath);
        if (!file.open(QIODevice::WriteOnly)) return "Failed to write temp file.";
        file.write(data);
        file.close();
    } else {
        filePath = imageDataBase64;
    }
    cv::Mat img = cv::imread(filePath.toStdString());
    if (img.empty()) return "Failed to load image.";

    auto input = preprocess(img);
    if (!input) return "Preprocessing failed.";

    if (!isModelLoaded || !module) return "Model not loaded.";

    const auto result = module->forward(std::vector<EValue>{EValue(*input)});
    if (!result.ok()) return QString("Inference failed: Error code %1").arg(static_cast<int>(result.error()));

    const auto& outputTensor = result->at(0).toTensor();
    const float* output = outputTensor.const_data_ptr<float>();
    int numOutputs = outputTensor.numel();

    if (numOutputs != 38) return QString("Unexpected output size: %1 (expected 38)").arg(numOutputs);

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

    // PlantVillage 38 labels (standard order)
    QStringList labels = {
        "Apple___Apple_scab", "Apple___Black_rot", "Apple___Cedar_apple_rust", "Apple___healthy",
        "Blueberry___healthy", "Cherry_(including_sour)___Powdery_mildew", "Cherry_(including_sour)___healthy",
        "Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot", "Corn_(maize)___Common_rust_",
        "Corn_(maize)___Northern_Leaf_Blight", "Corn_(maize)___healthy",
        "Grape___Black_rot", "Grape___Esca_(Black_Measles)", "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)", "Grape___healthy",
        "Orange___Haunglongbing_(Citrus_greening)", "Peach___Bacterial_spot", "Peach___healthy",
        "Pepper,_bell___Bacterial_spot", "Pepper,_bell___healthy",
        "Potato___Early_blight", "Potato___Late_blight", "Potato___healthy",
        "Raspberry___healthy", "Soybean___healthy",
        "Squash___Powdery_mildew",
        "Strawberry___Leaf_scorch", "Strawberry___healthy",
        "Tomato___Bacterial_spot", "Tomato___Early_blight", "Tomato___Late_blight", "Tomato___Leaf_Mold",
        "Tomato___Septoria_leaf_spot", "Tomato___Spider_mites Two-spotted_spider_mite", "Tomato___Target_Spot",
        "Tomato___Tomato_Yellow_Leaf_Curl_Virus", "Tomato___Tomato_mosaic_virus", "Tomato___healthy"
    };

    QString label = labels.value(topClassIdx, "Unknown");
    return QString("Predicted: %1 (%.1f%% confidence)").arg(label).arg(topConfidence);
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

