import QtQuick 2.0
import org.dragly.veggtrafikant 1.0

Item {
    id: weatherSettingsRoot

    focus: true

    Component.onCompleted: {
        locationTextEdit.text = settingsStorage.value("yrLocationString", "Norge/Oslo/Oslo/Oslo")
    }

    onActiveFocusChanged: {
        if(activeFocus) {
            locationTextEdit.focus = true
        }
    }

    SettingsStorage {
        id: settingsStorage
    }

    Column {
        anchors.fill: parent
        spacing: settingsRoot.height * 0.02
        SettingsHeading {
            text: qsTr("Location")
        }
        SettingsTextEdit {
            id: locationTextEdit

            onTextChanged: {
                settingsStorage.setValue("yrLocationString", text)
            }
        }
        Text {
            text: qsTr("See http://om.yr.no/verdata/xml/ for more information.")
            font.pixelSize: parent.width * 0.03
            color: theme.duseFront
        }
    }
}
