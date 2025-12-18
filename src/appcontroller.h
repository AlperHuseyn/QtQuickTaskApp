#pragma once

#include <QObject>
#include <QString>

class TaskModel;

class AppController : public QObject {
    Q_OBJECT
    Q_PROPERTY(TaskModel* model READ model CONSTANT)
    Q_PROPERTY(QString storagePath READ storagePath CONSTANT)

public:
    explicit AppController(QObject* parent = nullptr);

    TaskModel* model() const;
    QString storagePath() const;

    Q_INVOKABLE void load();
    Q_INVOKABLE void save();
    Q_INVOKABLE void exportTasks(const QString& filePath);

private:
    QString defaultStoragePath() const;

    TaskModel* m_model;
    QString m_storagePath;
};