import QtQuick 2.0
import QtQuick.Controls 1.1
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
        TextField {
            id: locationTextEdit

            height: parent.width * 0.05
            width: parent.width
            font.pixelSize: height * 0.5
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
