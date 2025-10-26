#ifndef MYHELPER_H
#define MYHELPER_H

#include <QObject>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QString>
#include <QtConcurrent>



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

    QString imagePreview();


signals:
    void imageReady();
    void isHompageChanged();

private:
    QString m_imagePath;
    bool isHompage;

};

#endif // MYHELPER_H
