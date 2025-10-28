#include "myhelper.h"
#include <QtConcurrent>
#include <QBuffer>
#include <QFile>
#include <QDebug>
#include <QMetaObject>
#include <QUrl>

MyHelper::MyHelper(QObject *parent)
    : QObject{parent},
    m_localPath(""),
    m_imagePath("")
{
}
/**
 * @brief MyHelper::imageToDataUrl
 * @param image
 */
void MyHelper::imageToDataUrl(const QImage &image)
{
    QtConcurrent::run([this, image]() {
        QByteArray ba;
        QBuffer buffer(&ba);
        buffer.open(QIODevice::WriteOnly);
        image.save(&buffer, "PNG");

        QString encoded = "data:image/png;base64," + ba.toBase64();
        QMetaObject::invokeMethod(this, [this, encoded]() {
            m_imagePath = encoded;
            m_localPath.clear();
            emit imageReady();
        }, Qt::QueuedConnection);
    });
}
/**
 * @brief MyHelper::loadImageFromContentUriAsync
 * @param uriString
 */
void MyHelper::loadImageFromContentUri(const QString &uriString)
{
    // Run heavy work in background
    QtConcurrent::run([this, uriString]() {
#if defined(Q_OS_ANDROID)
        // 1) call Java helper to get Base64 string
        QJniObject activity = QNativeInterface::QAndroidApplication::context();
        if (!activity.isValid()) {
            qWarning() << "MyHelper: no Android activity";
            return;
        }

        QJniObject base64Str = QJniObject::callStaticObjectMethod(
            "com/plantGPT/GalleryHelper",
            "loadContentUri",
            "(Landroid/app/Activity;Ljava/lang/String;)Ljava/lang/String;",
            activity.object<jobject>(),
            QJniObject::fromString(uriString).object<jstring>()
            );

        if (!base64Str.isValid()) {
            qWarning() << "MyHelper: Java returned invalid string";
            return;
        }

        QString encoded = base64Str.toString();
        if (encoded.isEmpty()) {
            qWarning() << "MyHelper: Java returned empty Base64";
            return;
        }

        // 2) decode Base64 to raw bytes
        QByteArray imageData = QByteArray::fromBase64(encoded.toUtf8());
#else
        // On desktop, uriString may already be a local path or file URL
        QByteArray imageData;
        if (uriString.startsWith("file://")) {
            QString filePath = QUrl(uriString).toLocalFile();
            imageData = QFile::readAll(filePath);
        } else {
            imageData = QFile::readAll(uriString);
        }
#endif

        if (imageData.isEmpty()) {
            qWarning() << "MyHelper: decoded image data is empty";
            return;
        }

        // 3) write to a temp file in cache
        QString cacheDir = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
        if (cacheDir.isEmpty()) {
            // fallback to writableLocation Temp
            cacheDir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        }
        QDir dir(cacheDir);
        if (!dir.exists())
            dir.mkpath(".");

        // create a unique filename
        QString fileName = QString("picked_%1.png").arg(QUuid::createUuid().toString());
        QString fullPath = dir.filePath(fileName);

        QFile outFile(fullPath);
        if (!outFile.open(QIODevice::WriteOnly)) {
            qWarning() << "MyHelper: failed to open file for writing:" << fullPath;
            return;
        }
        outFile.write(imageData);
        outFile.close();

        // 4) update m_localPath on the GUI thread and emit signal
        QMetaObject::invokeMethod(this, [this, fullPath]() {
            // Use file:// URL in QML Image source or raw path depending on your UI
            m_localPath = QUrl::fromLocalFile(fullPath).toString(); // "file:///..."
            m_imagePath.clear();
            emit imageReady();
        }, Qt::QueuedConnection);
    });
}
/**
 * @brief MyHelper::imagePreview
 * @return
 */
QString MyHelper::imagePreview()
{
    return m_imagePath;
}
/**
 * @brief MyHelper::localFilePath
 * @return
 */
QString MyHelper::localFilePath()
{
    return m_localPath;
}
/**
 * @brief MyHelper::getIsHompage
 * @return
 */
bool MyHelper::getIsHompage() const
{
    return isHompage;
}
/**
 * @brief MyHelper::setIsHompage
 * @param newIsHompage
 */
void MyHelper::setIsHompage(bool newIsHompage)
{
    if (isHompage == newIsHompage)
        return;
    isHompage = newIsHompage;
    emit isHompageChanged();
}
