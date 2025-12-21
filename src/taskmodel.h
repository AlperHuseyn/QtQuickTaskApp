#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QString>
#include <QVector>

struct TaskItem {
    QString title;
    bool done;
    TaskItem(const QString& title = "", bool done = false)
        : title(title), done(done) {}
};

class TaskModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum Roles { TitleRole = Qt::UserRole + 1, DoneRole };

    explicit TaskModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addTask(const QString& title);
    Q_INVOKABLE void removeTask(int row);
    Q_INVOKABLE void toggleTask(int row);
    Q_INVOKABLE void clearCompleted();
    Q_INVOKABLE bool hasCompletedTasks() const;

    QVector<TaskItem> items() const;
    void setItems(const QVector<TaskItem>& items);

signals:
    void completedTasksChanged();

private:
    QVector<TaskItem> m_items;
};