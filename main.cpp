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
#include "qtquick2applicationviewer.h"
//#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("Dragly");
    QCoreApplication::setOrganizationDomain("dragly.org");
    QCoreApplication::setApplicationName("Veggtrafikant");

    QGuiApplication app(argc, argv);
    // IMPORTANT: This must match the Android package name for QSettings to work on Android.
    qmlRegisterType<Settings>("org.dragly.veggtrafikant", 1, 0, "SettingsStorage");

    QFontDatabase database;
    if(!database.addApplicationFont(":/fonts/ubuntu/Ubuntu-R.ttf")) {
        qWarning() << "Could not load Ubuntu font!";
    }
    app.setFont(QFont("Ubuntu"));
//    qDebug() << "font loaded";

    QPixmap nullCursor(16, 16);
    nullCursor.fill(Qt::transparent);
//    app.setOverrideCursor(QCursor(nullCursor));

    QtQuick2ApplicationViewer viewer;
    QSurfaceFormat surfaceFormat;
    surfaceFormat.setAlphaBufferSize(8);
    viewer.setClearBeforeRendering(true);
    viewer.setColor(QColor(Qt::transparent));
    viewer.setFlags(Qt::FramelessWindowHint);
    viewer.setFormat(surfaceFormat);
    //    viewer.setSurfaceType(QSurface::OpenGLSurface);
    //    QGLWidget* glWidget = new QGLWidget();
    //    glWidget->setAutoFillBackground(false);
    //    viewer.setViewport(glWidget);
    //    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QStringLiteral("qml/veggtrafikant/main.qml"));
    //    viewer.rootObject()->setProperty("stations", stationID);
//        viewer.showFullScreen();
    viewer.showExpanded();
    return app.exec();
}
