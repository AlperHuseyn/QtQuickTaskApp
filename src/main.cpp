#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include "appcontroller.h"
#include "taskmodel.h"
#include "settingsstore.h"

static QObject* settingsStoreSingletonProvider(QQmlEngine*, QJSEngine*) {
    return new SettingsStore();
}

int main(int argc, char *argv[]) {
    // Enable accessibility if QT_ACCESSIBILITY env var is set or --accessibility flag is passed
    // This must be done before QGuiApplication is created
    bool accessibilityRequested = qEnvironmentVariableIsSet("QT_ACCESSIBILITY");
    
    // Quick check for --accessibility flag in argv before QGuiApplication
    for (int i = 1; i < argc; ++i) {
        if (QString(argv[i]) == "--accessibility" || QString(argv[i]) == "-a") {
            accessibilityRequested = true;
            break;
        }
    }
    
    if (accessibilityRequested) {
        qputenv("QT_ACCESSIBILITY", "1");
    }
    
    QGuiApplication app(argc, argv);

    // Set application identifiers for QSettings
    app.setOrganizationName("MyOrganization");
    app.setOrganizationDomain("myorganization.example.com");
    app.setApplicationName("QtQuickTaskApp");
    
    // Set up command line parser for help text
    QCommandLineParser parser;
    parser.setApplicationDescription("QtQuickTaskApp - A task management application");
    parser.addHelpOption();
    parser.addVersionOption();
    
    QCommandLineOption accessibilityOption(QStringList() << "a" << "accessibility",
        "Enable accessibility support for automation tools and screen readers");
    parser.addOption(accessibilityOption);
    
    parser.process(app);

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