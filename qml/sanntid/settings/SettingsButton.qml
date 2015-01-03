import QtQuick 2.3

Item {
    id: settingsButtonRoot
    signal clicked
    property alias text: buttonText.text
    height: parent.width * 0.1
    width: parent.width
    Rectangle {
        anchors.fill: parent
        radius: 8
        color: theme.duseBack
    }
    Text {
        id: buttonText
        anchors.centerIn: parent
        text: qsTr("Add")
        font.pixelSize: parent.height * 0.4
        font.weight: Font.Light
        color: theme.strongFront
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            settingsButtonRoot.clicked()
        }
    }
}
