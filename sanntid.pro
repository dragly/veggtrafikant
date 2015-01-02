QT += opengl qml quick
QT += xmlpatterns xml

greaterThan(QT_MAJOR_VERSION, 4): DEFINES += QT_VERSION_IS_FIVE

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    settings.cpp

RESOURCES += \
    resources.qrc \
    qml.qrc

TARGET = rutetid

OTHER_FILES += \
    android/AndroidManifest.xml \
    todo.md \
    android/src/org/dragly/rutetid/AlwaysOnActivity.java

HEADERS += \
    settings.h

android {
    TARGET = Sanntid
} else {
    TARGET = sanntid
}

## Please do not modify the following two lines. Required for deployment.
#include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
#qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
