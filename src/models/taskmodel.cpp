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
    }

    return {};
}

QHash<int, QByteArray> TaskModel::roleNames() const {
    return {{TitleRole, "title"}, {DoneRole, "done"}};
}

void TaskModel::addTask(const QString& title) {
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(TaskItem(title, false));
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