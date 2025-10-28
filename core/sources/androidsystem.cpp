#include "androidsystem.h"

AndroidSystem::AndroidSystem(QObject *parent)
    : QObject{parent}
{
#if defined(Q_OS_ANDROID)
    requestCameraPeremision();
    requestReadExternalStorage();
#endif
}

/**
 * @brief AndroidSystem::openGallery
 * open gallarry
 */
void AndroidSystem::openGallery()
{
#if defined(Q_OS_ANDROID)
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    if (!activity.isValid()) {
        qWarning() << "Failed to get Android activity";
        return;
    }

    QJniObject::callStaticMethod<void>(
        "com/plantGPT/GalleryHandler",
        "openGallery",
        "(Landroid/app/Activity;)V",
        activity.object<jobject>()
        );
#endif
}



void AndroidSystem::requestCameraPeremision()
{
    QCameraPermission camerPermission;
    qApp->requestPermission(camerPermission,this,[this](const QPermission &results) {
        //checking the result
        if(results.status() == Qt::PermissionStatus::Denied) {
            qDebug()<< "Camers Access Denied";
        } else if(results.status() == Qt::PermissionStatus::Undetermined) {
            qDebug()<< "Camera Status Undefined. Make sure that the Camera is Oky and try again";
        }else if(results.status() == Qt::PermissionStatus::Granted) {
            qDebug()<< "Camera Access granted";
        }

    });
}


void AndroidSystem::requestReadExternalStorage()
{
#if defined(Q_OS_ANDROID)
    // Get the Qt Android activity
    qDebug() << "Invoking the request";
    QJniObject activity = QNativeInterface::QAndroidApplication::context();

    if (!activity.isValid()) {
        qWarning() << "Failed to get Android activity";
        return;
    }

    // Call the Java method to request storage permission
    QJniObject::callStaticMethod<void>(
        "com/plantGPT/RequestReadExternalStorage",
        "requestStoragePermission",
        "(Landroid/app/Activity;)V",
        activity.object<jobject>()
        );
#endif
}


