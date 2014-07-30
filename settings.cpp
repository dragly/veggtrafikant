#include "settings.h"
#include <QDebug>

Settings::Settings(QObject *parent) :
    QSettings(parent)
{
    qDebug() << "Settings are stored to " << fileName();
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue)
{
    return QSettings::value(key, defaultValue);
}

void Settings::setValue(const QString &key, const QVariant &value)
{
    QSettings::setValue(key, value);
}
