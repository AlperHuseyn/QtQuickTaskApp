#include "taskmodel.h"

TaskModel::TaskModel(QObject* parent)
    : QAbstractListModel(parent) {}

int TaskModel::rowCount(const QModelIndex& parent) const {
    return parent.isValid() ? 0 : m_items.size();
}

QVariant TaskModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || index.row() >= m_items.size()) return {};

    const TaskItem& task = m_items[index.row()];
    switch (role) {
    case TitleRole: return task.title;
    case DoneRole: return task.done;
    case DayRole: return task.day;
    case HourRole: return task.hour;
    case TaskTypeRole: return task.taskType;
    case NotesRole: return task.notes;
    case DateTimeRole: return task.dateTime;
    }

    return {};
}

QHash<int, QByteArray> TaskModel::roleNames() const {
    return {
        {TitleRole, "title"}, 
        {DoneRole, "done"},
        {DayRole, "day"},
        {HourRole, "hour"},
        {TaskTypeRole, "taskType"},
        {NotesRole, "notes"},
        {DateTimeRole, "dateTime"}
    };
}

void TaskModel::addTask(const QString& title) {
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(TaskItem(title, false, -1, -1, "other", "", QDateTime()));
    endInsertRows();
}

void TaskModel::addTimetableTask(const QString& title, int day, int hour, 
                                  const QString& taskType, const QString& notes,
                                  const QString& dateTimeStr) {
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    QDateTime dt = QDateTime::fromString(dateTimeStr, Qt::ISODate);
    m_items.append(TaskItem(title, false, day, hour, taskType, notes, dt));
    endInsertRows();
}

void TaskModel::updateTaskNotes(int row, const QString& notes) {
    if (row < 0 || row >= m_items.size()) return;
    m_items[row].notes = notes;
    emit dataChanged(index(row), index(row), {NotesRole});
}

void TaskModel::removeTask(int row) {
    if (row < 0 || row >= m_items.size()) return;
    beginRemoveRows(QModelIndex(), row, row);
    m_items.remove(row);
    endRemoveRows();
}

void TaskModel::toggleTask(int row) {
    if (row < 0 || row >= m_items.size()) return;
    m_items[row].done = !m_items[row].done;
    emit dataChanged(index(row), index(row), {DoneRole});
    emit completedTasksChanged();
}

void TaskModel::clearCompleted() {
    for (int i = m_items.size() - 1; i >= 0; --i) {
        if (m_items[i].done) removeTask(i);
    }
    emit completedTasksChanged();
}

bool TaskModel::hasCompletedTasks() const {
    for (const TaskItem& task : m_items) {
        if (task.done) return true;
    }
    return false;
}

QVector<TaskItem> TaskModel::items() const {
    return m_items;
}

void TaskModel::setItems(const QVector<TaskItem>& items) {
    beginResetModel();
    m_items = items;
    endResetModel();
    emit completedTasksChanged();
}

QVariantList TaskModel::getTasksForCell(int day, int hour, const QString& weekStart) const {
    QVariantList result;
    QDateTime weekStartDate = QDateTime::fromString(weekStart, Qt::ISODate);
    
    for (int i = 0; i < m_items.size(); ++i) {
        const TaskItem& task = m_items[i];
        
        // For timetable tasks (with valid day/hour)
        if (task.day == day && task.hour == hour) {
            // Check if task is in current week
            if (weekStartDate.isValid() && task.dateTime.isValid()) {
                QDateTime weekEndDate = weekStartDate.addDays(7);
                if (task.dateTime >= weekStartDate && task.dateTime < weekEndDate) {
                    QVariantMap taskMap;
                    taskMap["index"] = i;
                    taskMap["title"] = task.title;
                    taskMap["done"] = task.done;
                    taskMap["taskType"] = task.taskType;
                    taskMap["notes"] = task.notes;
                    result.append(taskMap);
                }
            } else if (!weekStartDate.isValid()) {
                // If no week filtering, show all tasks for this day/hour
                QVariantMap taskMap;
                taskMap["index"] = i;
                taskMap["title"] = task.title;
                taskMap["done"] = task.done;
                taskMap["taskType"] = task.taskType;
                taskMap["notes"] = task.notes;
                result.append(taskMap);
            }
        }
    }
    
    return result;
}

int TaskModel::getTaskCount(int day, int hour, const QString& weekStart) const {
    return getTasksForCell(day, hour, weekStart).size();
}