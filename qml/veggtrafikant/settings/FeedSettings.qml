import QtQuick 2.0
import QtQuick.Controls 1.1
import org.dragly.veggtrafikant 1.0

Item {
    id: feedSettingsRoot

    signal done()

    focus: true

    Component.onCompleted: {
        feedTextEdit.text = settingsStorage.value("feedURL", "http://www.nrk.no/nyheiter/siste.rss")
    }

    onActiveFocusChanged: {
        if(activeFocus) {
            feedTextEdit.focus = true
        }
    }

    SettingsStorage {
        id: settingsStorage
    }

    Column {
        anchors.fill: parent
        spacing: settingsRoot.height * 0.02
        SettingsHeading {
            text: qsTr("Feed Location")
        }
        TextField {
            id: feedTextEdit

            height: parent.width * 0.05
            width: parent.width
            font.pixelSize: height * 0.5

            onTextChanged: {
                settingsStorage.setValue("feedURL", text)
            }
        }
    }
}
