#ifndef MODELRUNNER_H
#define MODELRUNNER_H

#include <QObject>
#include <QImage>
#include <QtCore>
#include <opencv2/opencv.hpp>
#include <executorch/extension/module/module.h>
#include <executorch/extension/tensor/tensor.h>
#include <executorch/runtime/core/evalue.h>
#include <executorch/runtime/core/error.h>

#include <QDebug>
#include <QStandardPaths>
#include <QFile>
#include <QDir>

using namespace ::executorch::extension;
using namespace ::executorch::runtime;
using Tensor = ::executorch::runtime::etensor::Tensor;

class ModelRunner : public QObject
{
    Q_OBJECT
public:
    explicit ModelRunner(QObject *parent = nullptr);

public slots:
    QString classifyImage(const QString &imagePath);

private:
    QScopedPointer<Module> module;
    bool isModelLoaded = false;
    void loadModel();
    TensorPtr preprocess(const cv::Mat &img);
    QImage matToQImage(const cv::Mat &mat);
    cv::Mat qImageToMat(const QImage &image);
    QString prepareModelFile();
};

#endif // MODELRUNNER_H
