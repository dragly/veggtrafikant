import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: stationSettingsOverlayRoot

    property alias minTime: minTimeTextEdit.text
//    property alias directions: directionsTextEdit.text

    signal done
    signal deleteStation
    signal cancel

    onDeleteStation: {
        Qt.inputMethod.hide()
    }
    onDone: {
        Qt.inputMethod.hide()
    }
    onCancel: {
        Qt.inputMethod.hide()
    }

    width: parent.width * 0.8
    height: parent.height * 0.4
    anchors.centerIn: parent

    Column {
        anchors.fill: parent
        anchors.margins: width * 0.02
        spacing: width * 0.02
//        columns: 2
//        columnSpacing: width * 0.02
//        rowSpacing: width * 0.02

        SettingsButton {
            id: doneButton
            text: qsTr("Save")
            height: stationSettingsOverlayRoot.width * 0.1

//            KeyNavigation.up: directionsTextEdit

            Keys.onPressed: {
                if(event.key === Qt.Key_Return) {
                    stationSettingsOverlayRoot.done()
                }
            }
            onClicked: {
                stationSettingsOverlayRoot.done()
            }
        }
        Text {
            text: "Minimum time:"
            font.pixelSize: parent.width * 0.05
            color: theme.strongFront
        }
        TextField {
            id: minTimeTextEdit
            text: "0"
            inputMethodHints: Qt.ImhDigitsOnly
            Layout.preferredHeight: parent.width * 0.1
            font.pixelSize: height * 0.5
            Layout.fillWidth: true
//            KeyNavigation.down: directionsTextEdit
        }
//        Text {
//            text: "Directions:"
//            font.pixelSize: parent.width * 0.05
//            color: focus ?  theme.strongFront : theme.duseFront
//        }
//        TextField {
//            id: directionsTextEdit
//            text: "0"
//            inputMethodHints: Qt.ImhDigitsOnly
//            Layout.preferredHeight: parent.width * 0.1
//            font.pixelSize: height * 0.5
//            onTextChanged: {

//            }
//            Layout.fillWidth: true
//            KeyNavigation.up: minTimeTextEdit
//            KeyNavigation.down: deleteButton
//        }
        SettingsButton {
            id: deleteButton
            text: qsTr("Delete")
            Layout.preferredHeight: parent.width * 0.1
//            KeyNavigation.up: directionsTextEdit

            Keys.onPressed: {
                if(event.key === Qt.Key_Return) {
                    deleteStation()
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    deleteStation()
                }
            }
        }
    }
//    Row {
//        anchors {
//            horizontalCenter: parent.horizontalCenter
//            bottom: parent.bottom
//            margins: parent.width * 0.05
//        }
//    }
}
