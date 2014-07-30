import QtQuick 2.0

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
            text: "Return to main view"
            onClicked: {
                returnToMainView()
            }
        }
        SettingsButton {
            text: "Exit Veggtrafikant"
            onClicked: {
                Qt.quit()
            }
        }
    }
}
