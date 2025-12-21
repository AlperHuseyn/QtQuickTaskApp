#pragma once

#include <QObject>
#include <QString>

class TaskModel;

class AppController : public QObject {
    Q_OBJECT
    Q_PROPERTY(TaskModel* model READ model CONSTANT)
    Q_PROPERTY(QString storagePath READ storagePath CONSTANT)
    Q_PROPERTY(QString currentUser READ currentUser WRITE setCurrentUser NOTIFY currentUserChanged)

public:
    explicit AppController(QObject* parent = nullptr);

    TaskModel* model() const;
    QString storagePath() const;
    QString currentUser() const;
    void setCurrentUser(const QString& username);

    Q_INVOKABLE void load();
    Q_INVOKABLE void save();
    Q_INVOKABLE void exportTasks(const QString& filePath);
    Q_INVOKABLE void clearTasks();

signals:
    void currentUserChanged();

private:
    QString defaultStoragePath() const;
    void updateStoragePath();

    TaskModel* m_model;
    QString m_storagePath;
    QString m_currentUser;
};