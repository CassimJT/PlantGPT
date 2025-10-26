#include "androidsystem.h"

AndroidSystem::AndroidSystem(QObject *parent)
    : QObject{parent}
{
#if defined(Q_OS_ANDROID)
    requestCameraPeremision();
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
