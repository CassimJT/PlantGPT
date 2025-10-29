#include "modelrunner.h"


ModelRunner::ModelRunner(QObject *parent)
    : QObject{parent},
    isModelLoaded(false)
{
    // Constructor
    // loadModel();  // Uncomment to auto-load on init
}

/**
 * @brief ModelRunner::classifyImage
 * @param imagePath
 * @return Inference result as QString
 */
QString ModelRunner::classifyImage(const QString &imagePath)
{
    if (!isModelLoaded) {
        return "Model not loaded.";
    }
    cv::Mat img = cv::imread(imagePath.toStdString());
    if (img.empty()) {
        return "Failed to load image.";
    }
    auto input = preprocess(img);
    if (!input) {
        return "Preprocessing failed.";
    }
    // Use vector<EValue> overload to avoid ambiguity
    const auto result = module->forward(std::vector<EValue>{EValue(*input)});
    if (!result.ok()) {
        // Fix: Error is enum; cast to int for code
        return QString("Inference failed: Error code %1").arg(static_cast<int>(result.error()));
    }
    const auto& outputTensor = result->at(0).toTensor();
    const float* output = outputTensor.const_data_ptr<float>();
    int numOutputs = outputTensor.numel();
    // Fix: Loop for sizes (no direct << overload)
    qDebug() << "Output shape: [";
    for (auto s : outputTensor.sizes()) {
        qDebug() << s << " ";
    }
    qDebug() << "]";
    qDebug() << "Num elements:" << numOutputs;
    qDebug() << "Output[0] =" << output[0];
    // Example: Return top score (adjust for argmax/class names)
    return QString("Inference result: %1 (shape: %2)").arg(output[0]).arg(numOutputs);
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
    QString targetPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/plant_disease_model.pt";
    if (QFile::exists(targetPath)) {
        return targetPath;
    }
    QString sourcePath = "asserts:/model/plant_disease_model.pt";
    QFile source(sourcePath);
    if (!source.exists()) {
        qDebug() << "Model file does not exist in assets:" << sourcePath;
        return {};
    }
    QDir().mkpath(QFileInfo(targetPath).path());
    if (!source.copy(targetPath)) {
        qDebug() << "Failed to copy model to internal storage!";
        return {};
    }
    qDebug() << "Model copied to:" << targetPath;
    return targetPath;
}
