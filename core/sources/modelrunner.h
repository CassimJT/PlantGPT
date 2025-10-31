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
#include <QByteArray>
#include <QBuffer>
#include <vector>
#include <algorithm>
#include <cmath>

using namespace ::executorch::extension;
using namespace ::executorch::runtime;
using Tensor = ::executorch::runtime::etensor::Tensor;

class ModelRunner : public QObject
{
    Q_PROPERTY(QString diseaseName READ diseaseName WRITE setDiseaseName NOTIFY diseaseNameChanged FINAL)

    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged FINAL)

    Q_PROPERTY(qreal confidence READ confidence WRITE setConfidence NOTIFY confidenceChanged FINAL)

    Q_PROPERTY(QString cure READ cure WRITE setCure NOTIFY cureChanged FINAL)

    Q_OBJECT
public:
    explicit ModelRunner(QObject *parent = nullptr);

    QString diseaseName() const;
    void setDiseaseName(const QString &newDiseaseName);

    QString description() const;
    void setDescription(const QString &newDescription);


    QString cure() const;
    void setCure(const QString &newCure);

    float confidence() const;
    void setConfidence(float newConfidence);

public slots:

    void classifyImage(const QString &imagePath);

signals:
    void diseaseNameChanged();

    void descriptionChanged();

    void cureChanged();

    void infarenceFinished();

    void confidenceChanged();

    void infarenceFaild();

private:
    QScopedPointer<Module> module;

    bool isModelLoaded = false;

    void loadModel();

    TensorPtr preprocess(const cv::Mat &img);

    QImage matToQImage(const cv::Mat &mat);

    cv::Mat qImageToMat(const QImage &image);

    QString prepareModelFile();

    QString className(int class_id);

    QString classDescripion(int class_id);

    QString classCure(int class_id);

    QString m_diseaseName;

    QString m_description;

    QString m_cure;

    float m_confidence;



};

#endif // MODELRUNNER_H
