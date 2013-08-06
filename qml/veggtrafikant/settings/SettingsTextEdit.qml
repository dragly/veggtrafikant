import QtQuick 2.0

Item {
    property alias text: textEdit.text

    onActiveFocusChanged: {
        if(activeFocus) {
            textEdit.focus = true
        }
    }

    height: parent.width * 0.05
    width: parent.width
    Rectangle {
        anchors.fill: parent
        color: textEdit.activeFocus ? "#0578AF" : "#00283B"
    }

    TextEdit {
        id: textEdit
        anchors {
            top: parent.top
            topMargin: parent.height * 0.2
            left: parent.left
            leftMargin: parent.width * 0.01
        }

        font.pixelSize: parent.height * 0.5
        color: activeFocus ? "white" : "#C6E6F6"
    }
}
