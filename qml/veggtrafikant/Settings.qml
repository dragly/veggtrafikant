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
                text: qsTr("Timetable")
                font.pixelSize: settingsRoot.width / 18
                color: "grey"
            }
            Text {
                id: weatherText
                text: qsTr("Weather")
                font.pixelSize: settingsRoot.width / 18
                color: "grey"
            }
            Text {
                id: exitText
                text: qsTr("Exit")
                font.pixelSize: settingsRoot.width / 18
                color: "grey"
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
            leftMargin: settingsRoot.width * 0.05
        }

        Item {
            id: timetableSettings
            enabled: false
            opacity: 0
            anchors.fill: parent
            anchors.topMargin: parent.height

            Column {
                anchors.fill: parent
                spacing: settingsRoot.height * 0.05
                Text {
                    text: qsTr("Stations")
                    font.pixelSize: parent.width / 20
                    color: "grey"
                }
            }
        }

        Item {
            id: weatherSettings
            enabled: false
            opacity: 0
            anchors.fill: parent
            anchors.topMargin: parent.height

            Column {
                anchors.fill: parent
                spacing: settingsRoot.height * 0.05
                Text {
                    text: qsTr("Location")
                    font.pixelSize: parent.width / 20
                    color: "grey"
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
            name: "exit"
            PropertyChanges {
                target: exitText
                color: "white"
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

    //    TextEdit {
    //        id: text_edit1
    //        x: 348
    //        y: 278
    //        width: 80
    //        height: 20
    //        text: qsTr("Text Edit")
    //        font.pixelSize: 12
    //    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Escape) {
            done()
            event.accepted = true
        }
        if(event.key === Qt.Key_Left || event.key === Qt.Key_Right) {
            var currentState = 0;
            var nextState = 0;
            for(var i in states) {
                if(state === states[i].name) {
                    currentState = parseInt(i);
                    break;
                }
            }
            if(event.key === Qt.Key_Left) {
                nextState = currentState - 1
            }
            if(event.key === Qt.Key_Right) {
                nextState = currentState + 1
            }
            if(nextState < 0) {
                nextState = states.length - 1
            }
            if(nextState >= states.length) {
                nextState = 0
            }
            console.log(nextState)
            state = states[nextState].name
        }
        if(event.key === Qt.Key_Return) {
            console.log(state)
            if(state === "exit") {
                Qt.quit()
            }
        }
    }
}
