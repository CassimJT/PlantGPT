#ifndef MYHELPER_H
#define MYHELPER_H

#include <QObject>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QString>
#include <QtConcurrent>
#include <QUrl>
#if defined(Q_OS_ANDROID)
#include <QJniObject>
#include <QJniEnvironment>
#endif


class MyHelper : public QObject
{
    Q_PROPERTY(bool isHompage READ getIsHompage WRITE setIsHompage NOTIFY isHompageChanged FINAL)
    Q_OBJECT
public:
    explicit MyHelper(QObject *parent = nullptr);
    bool getIsHompage() const;


public slots:
    void setIsHompage(bool newIsHompage);

    void imageToDataUrl(const QImage &image);

    void loadImageFromContentUri(const QString &uri);

    QString localFilePath();

    QString imagePreview();


signals:
    void imageReady();
    void isHompageChanged();

private:
    QString m_imagePath;
    QString m_localPath;
    bool isHompage;

};

#endif // MYHELPER_H
