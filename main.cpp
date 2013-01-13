#include <QApplication>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));


    QPixmap nullCursor(16, 16);
    nullCursor.fill(Qt::transparent);
    app->setOverrideCursor(QCursor(nullCursor));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/veggtrafikant/main.qml"));
    viewer.showFullScreen();


    return app->exec();
}
