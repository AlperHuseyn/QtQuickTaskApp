#pragma once

#include <QObject>
#include <QString>

class SettingsStore final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
public:
    explicit SettingsStore(QObject* parent = nullptr);

    QString username() const;
    void setUsername(const QString& value);

    signals:
        void usernameChanged();

private:
    QString m_username;
};