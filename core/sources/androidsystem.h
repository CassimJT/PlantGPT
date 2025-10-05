#ifndef ANDROIDSYSTEM_H
#define ANDROIDSYSTEM_H

#include <QObject>

class AndroidSystem : public QObject
{
    Q_OBJECT
public:
    explicit AndroidSystem(QObject *parent = nullptr);

signals:
};

#endif // ANDROIDSYSTEM_H
