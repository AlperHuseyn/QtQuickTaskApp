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
    case HourRole: return task.hour;
    case CategoryRole: return task.category;
    case NotesRole: return task.notes;
    case RepsRole: return task.reps;
    case WeightRole: return task.weight;
    case SetsRole: return task.sets;
    }

    return {};
}

QHash<int, QByteArray> TaskModel::roleNames() const {
    return {
        {TitleRole, "title"}, 
        {DoneRole, "done"},
        {HourRole, "hour"},
        {CategoryRole, "category"},
        {NotesRole, "notes"},
        {RepsRole, "reps"},
        {WeightRole, "weight"},
        {SetsRole, "sets"}
    };
}

void TaskModel::addTask(const QString& title) {
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(TaskItem(title, false));
    endInsertRows();
}

void TaskModel::addTask(const QString& title, int hour, const QString& category) {
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(TaskItem(title, false, hour, category));
    endInsertRows();
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

void TaskModel::updateTaskNotes(int row, const QString& notes) {
    if (row < 0 || row >= m_items.size()) return;
    m_items[row].notes = notes;
    emit dataChanged(index(row), index(row), {NotesRole});
}

void TaskModel::updateWorkoutDetails(int row, int reps, double weight, int sets) {
    if (row < 0 || row >= m_items.size()) return;
    m_items[row].reps = reps;
    m_items[row].weight = weight;
    m_items[row].sets = sets;
    emit dataChanged(index(row), index(row), {RepsRole, WeightRole, SetsRole});
}

QVariantList TaskModel::getTasksForHour(int hour) const {
    QVariantList result;
    for (int i = 0; i < m_items.size(); ++i) {
        if (m_items[i].hour == hour) {
            QVariantMap taskMap;
            taskMap["index"] = i;
            taskMap["title"] = m_items[i].title;
            taskMap["done"] = m_items[i].done;
            taskMap["category"] = m_items[i].category;
            taskMap["notes"] = m_items[i].notes;
            taskMap["reps"] = m_items[i].reps;
            taskMap["weight"] = m_items[i].weight;
            taskMap["sets"] = m_items[i].sets;
            result.append(taskMap);
        }
    }
    return result;
}