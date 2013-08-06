import QtQuick 2.0
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
        SettingsTextEdit {
            id: feedTextEdit

            onTextChanged: {
                settingsStorage.setValue("feedURL", text)
            }
        }
    }
}
