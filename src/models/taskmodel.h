#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QString>
#include <QVector>
#include <QDateTime>

struct TaskItem {
    QString title;
    bool done;
    int day;           // 0-6 (0=Sunday, 6=Saturday)
    int hour;          // 5-22 (5AM to 10PM)
    QString taskType;  // "workout", "work", "meeting", "other", etc.
    QString notes;
    QDateTime dateTime; // For week navigation
    
    TaskItem(const QString& title = "", bool done = false, 
             int day = -1, int hour = -1, 
             const QString& taskType = "other", const QString& notes = "",
             const QDateTime& dateTime = QDateTime())
        : title(title), done(done), day(day), hour(hour), 
          taskType(taskType), notes(notes), dateTime(dateTime) {}
};

class TaskModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum Roles { 
        TitleRole = Qt::UserRole + 1, 
        DoneRole,
        DayRole,
        HourRole,
        TaskTypeRole,
        NotesRole,
        DateTimeRole
    };

    explicit TaskModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addTask(const QString& title);
    Q_INVOKABLE void addTimetableTask(const QString& title, int day, int hour, 
                                      const QString& taskType, const QString& notes,
                                      const QString& dateTimeStr);
    Q_INVOKABLE void updateTaskNotes(int row, const QString& notes);
    Q_INVOKABLE void removeTask(int row);
    Q_INVOKABLE void toggleTask(int row);
    Q_INVOKABLE void clearCompleted();
    Q_INVOKABLE bool hasCompletedTasks() const;
    Q_INVOKABLE QVariantList getTasksForCell(int day, int hour, const QString& weekStart) const;
    Q_INVOKABLE int getTaskCount(int day, int hour, const QString& weekStart) const;

    QVector<TaskItem> items() const;
    void setItems(const QVector<TaskItem>& items);

signals:
    void completedTasksChanged();

private:
    QVector<TaskItem> m_items;
};