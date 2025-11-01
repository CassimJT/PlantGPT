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

    Q_PROPERTY(int classIndex READ classIndex WRITE setClassIndex NOTIFY classIndexChanged FINAL)


    Q_OBJECT
public:
    explicit ModelRunner(QObject *parent = nullptr);

    QString diseaseName() const;
    Q_INVOKABLE void setDiseaseName(const QString &newDiseaseName);

    QString description() const;
    Q_INVOKABLE void setDescription(const QString &newDescription);


    QString cure() const;
    Q_INVOKABLE void setCure(const QString &newCure);

    float confidence() const;
    Q_INVOKABLE void setConfidence(float newConfidence);


    int classIndex() const;
    Q_INVOKABLE void setClassIndex(int newClassIndex);

public slots:

    void classifyImage(const QString &imagePath);

    QString className(int class_id);

    QString classDescripion(int class_id);

    QString classCure(int class_id);

signals:
    void diseaseNameChanged();

    void descriptionChanged();

    void cureChanged();

    void infarenceFinished();

    void confidenceChanged();

    void infarenceFaild();


    void classIndexChanged();

private:
    QScopedPointer<Module> module;

    bool isModelLoaded = false;

    void loadModel();

    TensorPtr preprocess(const cv::Mat &img);

    QImage matToQImage(const cv::Mat &mat);

    cv::Mat qImageToMat(const QImage &image);

    QString prepareModelFile();

    QString m_diseaseName;

    QString m_description;

    QString m_cure;

    float m_confidence;

    int m_classIndex;


};

#endif // MODELRUNNER_H
