import QtQuick 2.3

// TODO: Selection of locations for Ruter
// TODO: Selection of times for locations for Ruter
// TODO: Selection of location for Yr
// TODO: Selection of units for Yr

Item {
    id: settingsRoot
    width: 800
    height: 600

    signal done()

    state: "timetable"

//    focus: true

    Component.onCompleted: {
        for(var i = 0; i < topLevelModel.count; i++) {
            dummyLoader.source = topLevelModel.get(i).contents
        }
        dummyLoader.source = ""
    }

//    onFocusChanged: {
//        if(focus) {
//            topLevelView.focus = true
//        }
//    }

    ListModel {
        id: topLevelModel
        ListElement {
            name: qsTr("Stops")
            contents: "settings/TravelSettings.qml"
        }
        ListElement {
            name: qsTr("Weather")
            contents: "settings/WeatherSettings.qml"
        }
//        ListElement {
//            name: "News feed"
//            contents: "settings/FeedSettings.qml"
//        }
        ListElement {
            name: qsTr("About")
            contents: "settings/About.qml"
        }
        ListElement {
            name: qsTr("Exit")
            contents: "settings/ExitSettings.qml"
        }
    }

    Item {
        id: topLevelViewContainer
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        width: parent.width * 0.4

        Rectangle {
            id: topLevelViewBackground
            anchors.fill: parent
            color: theme.duseBack
            opacity: 0.7
        }

        Text {
            id: settingsText
            anchors {
                left: parent.left
                top: parent.top
                topMargin: parent.width * 0.07
                leftMargin: parent.width * 0.2
            }

            text: qsTr("Settings")
            color: theme.middle
            font.pixelSize: parent.width * 0.1
            font.weight: Font.Light
        }

        ListView {
            id: topLevelView
            anchors {
                top: settingsText.bottom
                topMargin: parent.width * 0.05
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            clip: true

            model: topLevelModel
            delegate: Item {
                id: delegateItem
                property variant myData: model
                width: topLevelView.width
                height: topLevelView.width * 0.1
                Text {
                    anchors {
                        leftMargin: parent.width * 0.2
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: model.name
                    color: delegateItem.ListView.isCurrentItem ? theme.strongBack : theme.strongFront
                    font.weight: Font.Light
                    font.pixelSize: delegateItem.height * 0.5

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        topLevelView.currentIndex = index
                        Qt.inputMethod.hide();
                    }
                }
            }
            highlight: Rectangle {
                width: topLevelView.width
                height: topLevelView.width * 0.2
                color: theme.middle
            }

            Keys.onPressed: {
//                if(event.key === Qt.Key_Return) {
//                    settingsView.focus = true
//                }
            }
        }
    }

    Connections {
        target: settingsView.item
        ignoreUnknownSignals: true
        onDone: {
//            topLevelView.focus = true
        }
        onReturnToMainView: {
            done()
        }
    }

    Item {
        id: settingsViewContainer

        anchors {
            left: topLevelViewContainer.right
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: theme.strongBack
            opacity: 0.7
        }

        Loader {
            id: settingsView
            anchors {
                fill: parent
                leftMargin: parent.width * 0.1
                rightMargin: parent.width * 0.1
                topMargin: parent.width * 0.04
            }

            source: topLevelView.currentItem.myData.contents

            Keys.onPressed: {
                if(event.key === Qt.Key_Escape) {
//                    topLevelView.focus = true
                    event.accepted = true
                }
            }
            Keys.onReleased: {
                if(event.key === Qt.Key_Back) {
//                    topLevelView.focus = true
                    event.accepted = true
                }
            }
        }
    }

    Loader {
        id: dummyLoader

        visible: false
        asynchronous: true
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Escape) {
            done()
            event.accepted = true
        }
        if (event.key === Qt.Key_Back) {
            done()
            event.accepted = true
        }
    }
    Keys.onReleased: {
        if(event.key === Qt.Key_Back) {
            done()
            event.accepted = true
        }
    }
}
