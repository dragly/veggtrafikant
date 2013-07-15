import QtQuick 2.0
import org.dragly.veggtrafikant 1.0

Item {
    id: weatherSettingsRoot
    enabled: false
    opacity: 0
    anchors.fill: parent
    anchors.topMargin: parent.height

    Component.onCompleted: {
        locationTextEdit.text = settingsStorage.value("yrLocationString", "Norge/Oslo/Oslo/Oslo")
    }

    onFocusChanged: {
        if(focus) {
            locationTextEdit.focus = true
        }
    }

    SettingsStorage {
        id: settingsStorage
    }

    Column {
        anchors.fill: parent
        spacing: settingsRoot.height * 0.02
        Text {
            text: qsTr("Location:")
            font.pixelSize: parent.width * 0.05
            color: "grey"
        }
        TextEdit {
            id: locationTextEdit
            height: parent.width * 0.05
            width: parent.width
            text: ""
            font.pixelSize: parent.width * 0.04
            color: activeFocus ? "white" : "grey"

            onTextChanged: {
                settingsStorage.setValue("yrLocationString", text)
            }
        }
        Text {
            text: qsTr("See http://om.yr.no/verdata/xml/ for more information.")
            font.pixelSize: parent.width * 0.03
            color: "grey"
        }
    }
}
