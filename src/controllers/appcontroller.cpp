#include "appcontroller.h"
#include "../models/taskmodel.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QSaveFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QRegularExpression>

AppController::AppController(QObject* parent)
    : QObject(parent), m_model(new TaskModel(this)),
      m_storagePath(defaultStoragePath()), m_currentUser("") {
    // Don't auto-load on construction - wait for user to be set
}

TaskModel* AppController::model() const {
    return m_model;
}

QString AppController::storagePath() const {
    return m_storagePath;
}

QString AppController::currentUser() const {
    return m_currentUser;
}

void AppController::setCurrentUser(const QString& username) {
    if (m_currentUser == username) return;
    
    // Save current user's tasks before switching
    if (!m_currentUser.isEmpty()) {
        save();
    }
    
    m_currentUser = username;
    updateStoragePath();
    
    // Clear and load new user's tasks
    if (!m_currentUser.isEmpty()) {
        load();
    } else {
        clearTasks();
    }
    
    emit currentUserChanged();
}

QString AppController::defaultStoragePath() const {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(path);
    return path + "/tasks.json";
}

void AppController::updateStoragePath() {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(path);
    
    if (m_currentUser.isEmpty()) {
        m_storagePath = path + "/tasks.json";
    } else {
        // Sanitize username for filename (replace invalid characters)
        QString safeUsername = m_currentUser;
        safeUsername.replace(QRegularExpression("[^a-zA-Z0-9_-]"), "_");
        m_storagePath = path + "/tasks_" + safeUsername + ".json";
    }
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
        TaskItem task(
            obj.value("title").toString(),
            obj.value("done").toBool(),
            obj.value("hour").toInt(-1),
            obj.value("category").toString("General"),
            obj.value("notes").toString(""),
            obj.value("reps").toInt(0),
            obj.value("weight").toDouble(0.0),
            obj.value("sets").toInt(0)
        );
        tasks.append(task);
    }
    m_model->setItems(tasks);
}

void AppController::save() {
    QJsonArray taskArray;
    for (const TaskItem& task : m_model->items()) {
        QJsonObject obj;
        obj["title"] = task.title;
        obj["done"] = task.done;
        obj["hour"] = task.hour;
        obj["category"] = task.category;
        obj["notes"] = task.notes;
        obj["reps"] = task.reps;
        obj["weight"] = task.weight;
        obj["sets"] = task.sets;
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

void AppController::clearTasks() {
    m_model->setItems(QVector<TaskItem>());
}