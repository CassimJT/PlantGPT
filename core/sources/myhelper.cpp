#include "myhelper.h"

MyHelper::MyHelper(QObject *parent)
    : QObject{parent}
{}


/**
 * @brief MyHelper::imageToDataUrl
 * @param image
 * convert image to data url
 */
void MyHelper::imageToDataUrl(const QImage &image)
{
    QtConcurrent::run([this, image]() {
        QByteArray ba;
        QBuffer buffer(&ba);
        buffer.open(QIODevice::WriteOnly);
        image.save(&buffer, "PNG");
        QString encoded = "data:image/png;base64," + ba.toBase64();
        //GUI thread
        QMetaObject::invokeMethod(this, [this, encoded]() {
            m_imagePath = encoded;
            emit imageReady();
        }, Qt::QueuedConnection);
    });
}
/**
 * @brief MyHelper::imagePreview
 * @return the preview path
 */
QString MyHelper::imagePreview()
{
    return m_imagePath;
}

bool MyHelper::getIsHompage() const
{
    return isHompage;
}

void MyHelper::setIsHompage(bool newIsHompage)
{
    if (isHompage == newIsHompage)
        return;
    isHompage = newIsHompage;
    emit isHompageChanged();
}
