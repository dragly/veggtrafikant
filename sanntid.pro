TEMPLATE = app

QT += qml quick widgets
QT += xmlpatterns xml

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    settings.cpp

RESOURCES += \
    resources.qrc \
    qml.qrc \
    translations.qrc

TARGET = sanntid

OTHER_FILES += \
    android/AndroidManifest.xml \
    todo.md \
    android/src/org/dragly/sanntid/AlwaysOnActivity.java

HEADERS += \
    settings.h

android {
    TARGET = Sanntid
}

TRANSLATIONS = sanntid_nb_NO.ts

## Please do not modify the following two lines. Required for deployment.
#include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
#qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

include(translations.pri)
