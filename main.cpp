#include <settings.h>

#include <QtGui/QGuiApplication>
#include <QQuickItem>
#include <QFontDatabase>
#include <QTranslator>
#include <QLibraryInfo>
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

    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(),
            QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator myappTranslator;
    qDebug() << ":/sanntid_" + QLocale::system().name();
    if(!myappTranslator.load(":/sanntid_" + QLocale::system().name())) {
        qDebug() << "Failed to load translation file!";
    }
    app.installTranslator(&myappTranslator);

    qDebug() << "Current locale: " << QLocale::system();

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
