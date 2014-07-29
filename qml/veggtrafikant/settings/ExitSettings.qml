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

            function runCurrentAction() {
                if(currentItem.myData.action === "return") {
                    returnToMainView()
                } else if(currentItem.myData.action === "exit") {
                    Qt.quit()
                }
            }

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
                    color: exitView.activeFocus && delegateItem.ListView.isCurrentItem ? theme.strongBack : theme.duseFront

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        exitView.currentIndex = index
                        exitView.runCurrentAction()
                    }
                }
            }

            highlight: Rectangle {
                width: topLevelView.width
                height: topLevelView.width * 0.2
                color: exitView.activeFocus ? theme.middle : "transparent"
            }

            Keys.onPressed: {
                if(event.key === Qt.Key_Return) {
                    runCurrentAction()
                }
            }
        }
    }
}
