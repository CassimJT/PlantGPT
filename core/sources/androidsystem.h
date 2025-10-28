#ifndef ANDROIDSYSTEM_H
#define ANDROIDSYSTEM_H

#include <QObject>
#include <QPermission>
#include <QtCore>
#if defined(Q_OS_ANDROID)
#include <QJniObject>
#include <QJniEnvironment>
#endif

#include <QDebug>


class AndroidSystem : public QObject
{
    Q_OBJECT
public:
    explicit AndroidSystem(QObject *parent = nullptr);

    Q_INVOKABLE void openGallery();

public slots:

signals:

private:
    void requestCameraPeremision();
    void requestReadExternalStorage();

};

#endif // ANDROIDSYSTEM_H
