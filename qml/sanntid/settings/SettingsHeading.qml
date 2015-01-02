import QtQuick 2.3

Item {
    property alias text: headingText.text
    height: parent.width * 0.12
    width: parent.width
    Text {
        id: headingText
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        font.pixelSize: parent.height * 0.4
        font.weight: Font.Light
        color: theme.middle
    }
}
