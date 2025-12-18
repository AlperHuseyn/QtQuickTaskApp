#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "appcontroller.h"
#include "taskmodel.h"
#include "settingsstore.h"

static QObject* settingsStoreSingletonProvider(QQmlEngine*, QJSEngine*) {
    return new SettingsStore();
}

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    // Set application identifiers for QSettings
    app.setOrganizationName("MyOrganization");
    app.setOrganizationDomain("myorganization.example.com");
    app.setApplicationName("QtQuickTaskApp");

    QQmlApplicationEngine engine;

    qmlRegisterType<TaskModel>("TaskApp", 1, 0, "TaskModel");
    qmlRegisterType<AppController>("TaskApp", 1, 0, "AppController");
    qmlRegisterSingletonType<SettingsStore>("TaskApp", 1, 0, "SettingsStore",
        settingsStoreSingletonProvider);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}