import QtQuick 2.0

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

    onFocusChanged: {
        if(focus) {
            timetableText.focus = true
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
        opacity: 0.7
    }

    Text {
        id: settingsText
        anchors {
            top: parent.top
            left: parent.left
        }

        text: qsTr("Veggtrafikant")
        font.pixelSize: parent.width / 10
        color: "white"
    }

    Item {
        id: tabMenu
        anchors {
            top: settingsText.bottom
            topMargin: settingsRoot.height * 0.02
            leftMargin: settingsRoot.width * 0.05
            left: settingsRoot.left
            right: settingsRoot.right
        }
        height: settingsRoot.height * 0.1
        Row {
            anchors.fill: parent
            spacing: settingsRoot.width * 0.05
            Text {
                id: timetableText
                text: qsTr("Stations")
                font.pixelSize: settingsRoot.width / 18
                color: "grey"
                KeyNavigation.right: weatherText
                KeyNavigation.left: exitText
                KeyNavigation.down: timetableSettings
                onActiveFocusChanged: {
                    if(activeFocus) {
                        settingsRoot.state = "timetable"
                    }
                }
                Keys.onPressed: {
                    if(event.key === Qt.Key_Return) {
                        timetableSettings.focus = true
                    }
                }
            }
            Text {
                id: weatherText
                text: qsTr("Weather")
                font.pixelSize: settingsRoot.width / 18
                color: "grey"
                KeyNavigation.right: feedText
                KeyNavigation.left: timetableText
                KeyNavigation.down: weatherSettings
                onActiveFocusChanged: {
                    if(activeFocus) {
                        settingsRoot.state = "weather"
                    }
                }
                Keys.onPressed: {
                    if(event.key === Qt.Key_Return) {
                        weatherSettings.focus = true
                    }
                }
            }
            Text {
                id: feedText
                text: qsTr("Feed")
                font.pixelSize: settingsRoot.width / 18
                color: "grey"
                KeyNavigation.right: exitText
                KeyNavigation.left: weatherText
                KeyNavigation.down: feedSettings
                onActiveFocusChanged: {
                    if(activeFocus) {
                        settingsRoot.state = "feed"
                    }
                }
                Keys.onPressed: {
                    if(event.key === Qt.Key_Return) {
                        feedSettings.focus = true
                    }
                }
            }
            Text {
                id: exitText
                text: qsTr("Exit")
                font.pixelSize: settingsRoot.width / 18
                color: "grey"
                KeyNavigation.right: timetableText
                KeyNavigation.left: feedText
                KeyNavigation.down: exitSettings
                onActiveFocusChanged: {
                    if(activeFocus) {
                        settingsRoot.state = "exit"
                    }
                }
                Keys.onPressed: {
                    if(event.key === Qt.Key_Return) {
                        exitSettings.focus = true
                    }
                }
            }
        }
    }

    Item {
        id: settingsPlaceholder
        anchors {
            top: tabMenu.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: settingsRoot.width * 0.1
        }

        TimetableSettings {
            id: timetableSettings
            enabled: false
            opacity: 0
            anchors.fill: parent
            anchors.topMargin: parent.height
        }

        WeatherSettings {
            id: weatherSettings
            enabled: false
            opacity: 0
            anchors.fill: parent
            anchors.topMargin: parent.height
        }

        FeedSettings {
            id: feedSettings
            enabled: false
            opacity: 0
            anchors.fill: parent
            anchors.topMargin: parent.height
        }

        Item {
            id: exitSettings
            enabled: false
            opacity: 0
            anchors.fill: parent
            anchors.topMargin: parent.height

            onFocusChanged: {
                if(focus) {
                    returnToMainViewText.focus = true
                }
            }

            Column {
                anchors.fill: parent
                spacing: parent.width * 0.02
                Text {
                    id: returnToMainViewText
                    text: qsTr("Return to main view")
                    font.pixelSize: parent.width * 0.05
                    color: activeFocus ? "white" : "grey"
                    KeyNavigation.down: quitText
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Return) {
                            settingsRoot.done()
                        }
                    }
                }
                Text {
                    id: quitText
                    text: qsTr("Quit Veggtrafikant")
                    font.pixelSize: parent.width * 0.05
                    color: activeFocus ? "white" : "grey"
                    KeyNavigation.up: returnToMainViewText
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Return) {
                            Qt.quit()
                        }
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "timetable"
            PropertyChanges {
                target: timetableText
                color: "white"
            }
            PropertyChanges {
                target: timetableSettings
                enabled: true
                opacity: 1
                anchors.topMargin: 0
            }
        },
        State {
            name: "weather"
            PropertyChanges {
                target: weatherText
                color: "white"
            }
            PropertyChanges {
                target: weatherSettings
                enabled: true
                opacity: 1
                anchors.topMargin: 0
            }
        },
        State {
            name: "feed"
            PropertyChanges {
                target: feedText
                color: "white"
            }
            PropertyChanges {
                target: feedSettings
                enabled: true
                opacity: 1
                anchors.topMargin: 0
            }
        },
        State {
            name: "exit"
            PropertyChanges {
                target: exitText
                color: "white"
            }
            PropertyChanges {
                target: exitSettings
                enabled: true
                opacity: 1
                anchors.topMargin: 0
            }
        }
    ]

    transitions: [
        Transition {
            ColorAnimation {
                properties: "color";
                easing.type: Easing.InOutQuad
                duration: 200
            }
            PropertyAnimation {
                properties: "opacity";
                easing.type: Easing.InOutQuad
                duration: 500
            }
        },
        Transition {
            from: "exit,weather,timetable"
            PropertyAnimation {
                properties: "anchors.topMargin";
                easing.type: Easing.OutBack
                duration: 500
                easing.overshoot: 1
            }
        }
    ]

    Keys.onPressed: {
        if(event.key === Qt.Key_Escape) {
            done()
            event.accepted = true
        }
    }
}
