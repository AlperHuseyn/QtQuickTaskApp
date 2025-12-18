#include "settingsstore.h"

#include <QSettings>

SettingsStore::SettingsStore(QObject* parent)
    : QObject(parent)
{
    QSettings s;
    m_username = s.value("user/username", "User").toString();
}

QString SettingsStore::username() const
{
    return m_username;
}

void SettingsStore::setUsername(const QString& value)
{
    if (value == m_username)
        return;
    m_username = value;

    QSettings s;
    s.setValue("user/username", m_username);
    s.sync();

    emit usernameChanged();
}