import QtQuick 2.3

Item {
    id: exitSettings

    signal returnToMainView()

    Column {
        anchors.fill: parent
        spacing: parent.width * 0.02
        SettingsHeading {
            text: qsTr("Exit Options")
        }
        id: exitModel
        SettingsButton {
            text: qsTr("Return to main view")
            onClicked: {
                returnToMainView()
            }
        }
        SettingsButton {
            text: qsTr("Exit Sanntid")
            onClicked: {
                Qt.quit()
            }
        }
    }
}
