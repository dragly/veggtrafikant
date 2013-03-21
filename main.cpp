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
#include "qtquick2applicationviewer.h"
//#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    //    QApplication::setGraphicsSystem("opengl");

//    QVariant stations;
//    if(argc > 1) {
//        for(int i = 1; i < argc; i++) {
//            stations << argv[i];
//        }
//    } else {
//        stations << "3010011";
//    }
//    qDebug() << stationID;

    QPixmap nullCursor(16, 16);
    nullCursor.fill(Qt::transparent);
    app.setOverrideCursor(QCursor(nullCursor));

    QtQuick2ApplicationViewer viewer;
//    QGLWidget* glWidget = new QGLWidget();
//    glWidget->setAutoFillBackground(false);
//    viewer.setViewport(glWidget);
//    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QStringLiteral("qml/veggtrafikant/main.qml"));
//    viewer.rootObject()->setProperty("stations", stationID);
    viewer.showFullScreen();
    //    viewer.show();


    return app.exec();
}
