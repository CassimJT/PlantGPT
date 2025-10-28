#ifndef MODELRUNNER_H
#define MODELRUNNER_H

#include <QObject>
#include <QImage>
#include <opencv2/opencv.hpp>
#include <executorch/extension/module/module.h>
#include <executorch/extension/tensor/tensor.h>


class ModelRunner : public QObject
{
    Q_OBJECT
public:
    explicit ModelRunner(QObject *parent = nullptr);
public slots:
    //QString classifyImage(const QString &imagePath);

signals:
private:
    // QImage matToQImage(const cv::Mat &mat);
    // void loadPlantClassificationModel();
    //bool isClassificationModelLoaded;
    //torch::Tensor preprocess(const cv::Mat &img);
};

#endif // MODELRUNNER_H
