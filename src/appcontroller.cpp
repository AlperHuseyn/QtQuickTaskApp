#include "appcontroller.h"
#include "taskmodel.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QSaveFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

AppController::AppController(QObject* parent)
    : QObject(parent), m_model(new TaskModel(this)),
      m_storagePath(defaultStoragePath()) {
    load();
}

TaskModel* AppController::model() const {
    return m_model;
}

QString AppController::storagePath() const {
    return m_storagePath;
}

QString AppController::defaultStoragePath() const {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(path);
    return path + "/tasks.json";
}

void AppController::load() {
    QFile file(m_storagePath);
    if (!file.exists()) return;

    if (!file.open(QIODevice::ReadOnly)) return;

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);

    if (!doc.isObject()) return;

    QJsonArray taskArray = doc.object().value("tasks").toArray();
    QVector<TaskItem> tasks;
    for (const QJsonValue& value : taskArray) {
        QJsonObject obj = value.toObject();
        tasks.append(TaskItem{obj.value("title").toString(), obj.value("done").toBool()});
    }
    m_model->setItems(tasks);
}

void AppController::save() {
    QJsonArray taskArray;
    for (const TaskItem& task : m_model->items()) {
        QJsonObject obj;
        obj["title"] = task.title;
        obj["done"] = task.done;
        taskArray.append(obj);
    }

    QJsonObject root;
    root["tasks"] = taskArray;

    QSaveFile file(m_storagePath);
    if (!file.open(QIODevice::WriteOnly)) return;

    file.write(QJsonDocument(root).toJson(QJsonDocument::Indented));
    file.commit();
}

void AppController::exportTasks(const QString& filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly)) return;

    save();
}