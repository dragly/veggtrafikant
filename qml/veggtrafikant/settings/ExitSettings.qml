import QtQuick 2.0

Item {
    id: exitSettings

    signal returnToMainView()

    focus: true

    onActiveFocusChanged: {
        if(activeFocus) {
            exitView.focus = true
        }
    }

    Column {
        anchors.fill: parent
        spacing: parent.width * 0.02
        SettingsHeading {
            text: qsTr("Exit Options")
        }
        ListModel {
            id: exitModel
            ListElement {
                text: "Return to main view"
                action: "return"
            }
            ListElement {
                text: "Exit Veggtrafikant"
                action: "exit"
            }
        }

        ListView {
            id: exitView
            model: exitModel
            width: parent.width
            height: parent.width * 0.1 * count

            delegate: Item {
                id: delegateItem
                property variant myData: model
                width: exitView.width
                height: exitSettings.width * 0.1
                Text {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: model.text
                    font.pixelSize: delegateItem.height * 0.5
                    font.weight: Font.Light
                    color: exitView.activeFocus && delegateItem.ListView.isCurrentItem ? "#EFEFEF" : "#00283B"

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }

            highlight: Rectangle {
                width: topLevelView.width
                height: topLevelView.width * 0.2
                color: exitView.activeFocus ? "#71CBF6" : "transparent"
            }

            Keys.onPressed: {
                if(event.key === Qt.Key_Return) {
                    if(currentItem.myData.action === "return") {
                        returnToMainView()
                    } else if(currentItem.myData.action === "exit") {
                        Qt.quit()
                    }
                }
            }
        }
    }
}
