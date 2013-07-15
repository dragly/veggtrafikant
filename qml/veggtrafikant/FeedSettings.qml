import QtQuick 2.0
import org.dragly.veggtrafikant 1.0

Item {
    id: weatherSettingsRoot
    enabled: false
    opacity: 0
    anchors.fill: parent
    anchors.topMargin: parent.height

    Component.onCompleted: {
        feedTextEdit.text = settingsStorage.value("feedURL", "http://www.nrk.no/nyheiter/siste.rss")
    }

    onFocusChanged: {
        if(focus) {
            feedTextEdit.focus = true
        }
    }

    SettingsStorage {
        id: settingsStorage
    }

    Column {
        anchors.fill: parent
        spacing: settingsRoot.height * 0.02
        Text {
            text: qsTr("Feed URL:")
            font.pixelSize: parent.width * 0.05
            color: "grey"
        }
        TextEdit {
            id: feedTextEdit
            height: parent.width * 0.05
            width: parent.width
            text: ""
            font.pixelSize: parent.width * 0.04
            color: activeFocus ? "white" : "grey"

            onTextChanged: {
                settingsStorage.setValue("feedURL", text)
            }
        }
    }
}
