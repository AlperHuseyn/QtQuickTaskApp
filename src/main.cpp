#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include "controllers/appcontroller.h"
#include "models/taskmodel.h"
#include "services/settingsstore.h"

static QObject* settingsStoreSingletonProvider(QQmlEngine*, QJSEngine*) {
    return new SettingsStore();
}

int main(int argc, char *argv[]) {
    // Enable accessibility by default for automation-scripts and screen reader support
    // NOTE: This must be done BEFORE QGuiApplication is created, but QCommandLineParser requires
    // QGuiApplication to exist. Therefore, we do a simple manual parse first, then set up the
    // proper QCommandLineParser later for help text and documentation.
    
    // Check if user explicitly disabled accessibility with --no-accessibility flag
    bool accessibilityDisabled = false;
    for (int i = 1; i < argc; ++i) {
        if (QString(argv[i]) == "--no-accessibility") {
            accessibilityDisabled = true;
            break;
        }
    }
    
    // Enable accessibility by default unless explicitly disabled
    // Note: We check if QT_ACCESSIBILITY is already set to allow users to override
    if (!accessibilityDisabled) {
        QByteArray currentValue = qgetenv("QT_ACCESSIBILITY");
        // Only set if not already set, or if set to 0/false (enable by default)
        if (currentValue.isEmpty() || currentValue == "0" || currentValue.toLower() == "false") {
            qputenv("QT_ACCESSIBILITY", "1");
        }
    } else {
        // User requested to disable - set to 0
        qputenv("QT_ACCESSIBILITY", "0");
    }
    
    QGuiApplication app(argc, argv);

    // Set application identifiers for QSettings
    app.setOrganizationName("MyOrganization");
    app.setOrganizationDomain("myorganization.example.com");
    app.setApplicationName("QtQuickTaskApp");
    
    // Set up command line parser for help text and documentation
    QCommandLineParser parser;
    parser.setApplicationDescription("QtQuickTaskApp - A task management application");
    parser.addHelpOption();
    parser.addVersionOption();
    
    QCommandLineOption noAccessibilityOption("no-accessibility",
        "Disable accessibility support (enabled by default)");
    parser.addOption(noAccessibilityOption);
    
    parser.process(app);

    QQmlApplicationEngine engine;

    qmlRegisterType<TaskModel>("TaskApp", 1, 0, "TaskModel");
    qmlRegisterType<AppController>("TaskApp", 1, 0, "AppController");
    qmlRegisterSingletonType<SettingsStore>("TaskApp", 1, 0, "SettingsStore",
        settingsStoreSingletonProvider);

    const QUrl url(QStringLiteral("qrc:/screens/AppEntry.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}