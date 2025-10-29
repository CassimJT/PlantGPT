#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "core/sources/androidsystem.h"
#include "core/sources/myhelper.h"
#include <QQmlContext>
#include "core/sources/modelrunner.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    //*******************************
    AndroidSystem android;
    MyHelper helper;
    ModelRunner modelRunner;
    //**************************

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("Android",&android);
    engine.rootContext()->setContextProperty("Helper",&helper);
    engine.rootContext()->setContextProperty("ModelRunner",&modelRunner);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("PlantGPT", "Main");

    return app.exec();
}
