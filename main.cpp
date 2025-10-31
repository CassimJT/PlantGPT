#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "core/sources/androidsystem.h"
#include "core/sources/myhelper.h"
#include <QQmlContext>
#include "core/sources/modelrunner.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    MyHelper helper;
    ModelRunner modelRunner;


    auto context = engine.rootContext();
    context->setContextProperty("Android", new AndroidSystem(&app));
    context->setContextProperty("Helper", &helper);
    context->setContextProperty("ModelRunner", &modelRunner);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("PlantGPT", "Main");

    return app.exec();
}
