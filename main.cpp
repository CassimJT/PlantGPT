#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "core/sources/androidsystem.h"
#include "core/sources/myhelper.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    AndroidSystem android;
    MyHelper helper;
    engine.rootContext()->setContextProperty("Android",&android);
    engine.rootContext()->setContextProperty("Helper",&helper);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("PlantGPT", "Main");

    return app.exec();
}
