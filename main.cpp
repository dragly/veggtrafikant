#include <settings.h>

#ifdef QT_VERSION_IS_FIVE
#include <QtGui/QGuiApplication>
#include <QQuickItem>
#else
#include <QtGui/QApplication>
#endif
#include <QDebug>
//#include <QDeclarativeContext>
#include <QGraphicsObject>
#include <QGLWidget>
#include <QFontDatabase>
//#include "qtquick2applicationviewer.h"
#include <QtQml/QQmlApplicationEngine>
//#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("Dragly");
    QCoreApplication::setOrganizationDomain("dragly.org");
    QCoreApplication::setApplicationName("Sanntid");
#ifdef Q_OS_ANDROID
//    QSettings::setPath(QSettings::NativeFormat, QSettings::UserScope, "/sdcard/.config/Dragly/Sanntid.conf");
#endif
    // IMPORTANT: This must match the Android package name for QSettings to work on Android.
    qmlRegisterType<Settings>("org.dragly.sanntid", 1, 0, "SettingsStorage");

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:/qml/sanntid/main.qml"));

    QFontDatabase database;
    if(!database.addApplicationFont(":/fonts/ubuntu/Ubuntu-R.ttf")) {
        qWarning() << "Could not load Ubuntu font!";
    }
    app.setFont(QFont("Ubuntu"));

//    QPixmap nullCursor(16, 16);
//    nullCursor.fill(Qt::transparent);
//    app.setOverrideCursor(QCursor(nullCursor));

    return app.exec();
}
