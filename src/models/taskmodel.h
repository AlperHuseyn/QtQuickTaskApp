#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QString>
#include <QVector>

struct TaskItem {
    QString title;
    bool done;
    int hour;           // Hour (7-21 for 7:00 AM - 9:00 PM, -1 for no time)
    QString category;   // Category (e.g., "Work", "Workout", "Personal")
    QString notes;      // General notes for the task
    int reps;          // For workout: repetitions
    double weight;     // For workout: weight in kg
    int sets;          // For workout: number of sets
    
    TaskItem(const QString& title = "", bool done = false, int hour = -1,
             const QString& category = "General", const QString& notes = "",
             int reps = 0, double weight = 0.0, int sets = 0)
        : title(title), done(done), hour(hour), category(category), 
          notes(notes), reps(reps), weight(weight), sets(sets) {}
};

class TaskModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum Roles { 
        TitleRole = Qt::UserRole + 1, 
        DoneRole,
        HourRole,
        CategoryRole,
        NotesRole,
        RepsRole,
        WeightRole,
        SetsRole
    };

    explicit TaskModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addTask(const QString& title);
    Q_INVOKABLE void addTask(const QString& title, int hour, const QString& category);
    Q_INVOKABLE void removeTask(int row);
    Q_INVOKABLE void toggleTask(int row);
    Q_INVOKABLE void clearCompleted();
    Q_INVOKABLE bool hasCompletedTasks() const;
    Q_INVOKABLE void updateTaskNotes(int row, const QString& notes);
    Q_INVOKABLE void updateWorkoutDetails(int row, int reps, double weight, int sets);
    Q_INVOKABLE QVariantList getTasksForHour(int hour) const;

    QVector<TaskItem> items() const;
    void setItems(const QVector<TaskItem>& items);

signals:
    void completedTasksChanged();

private:
    QVector<TaskItem> m_items;
};