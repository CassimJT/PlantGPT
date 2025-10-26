#ifndef ANDROIDSYSTEM_H
#define ANDROIDSYSTEM_H

#include <QObject>
#include <QPermission>
#include <QtCore>

class AndroidSystem : public QObject
{
    Q_OBJECT
public:
    explicit AndroidSystem(QObject *parent = nullptr);

public slots:

signals:

private:
    void requestCameraPeremision();
};

#endif // ANDROIDSYSTEM_H
