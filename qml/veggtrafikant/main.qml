import QtQuick 2.0
import QtGraphicalEffects 1.0
import org.dragly.veggtrafikant 1.0

Rectangle {
    id: root

    width: 480
    height: 480
    smooth: true
    focus: true

    Keys.onPressed: {
        if(event.key === Qt.Key_Q && event.modifiers & Qt.ControlModifier) {
            Qt.quit()
        }
        if(event.key === Qt.Key_Escape) {
            state = "settings"
        }
    }

    gradient: Gradient {
        GradientStop{ position: 0.0; color: "#9ac1d4" }
        GradientStop{ position: 0.2; color: "#84b9d1" }
        GradientStop{
            position: 0.8;
            SequentialAnimation on color {
                loops: Animation.Infinite
                ColorAnimation { from: "#466fab"; to: "#618cbf"; duration: 10000 }
                ColorAnimation { from: "#618cbf"; to: "#466fab"; duration: 10000 }
            }
        }
    }

    TravelTimes {
        id: travelTimes
        x: 0
        y: 0
        width: parent.width
        height: parent.height
    }

    GaussianBlur {
        id: travelTimesBlur
        anchors.fill: parent
        source: travelTimes
        radius: parent.width / 48
        samples: 16
        enabled: false
        opacity: 0
    }

    Settings {
        id: settings
        anchors.fill: parent
        enabled: false
        opacity: 0
        z: 999
        onDone: {
            root.state = ""
            root.focus = true
            travelTimes.refresh()
        }
    }

    states: [
        State {
            name: "settings"
            PropertyChanges {
                target: settings
                enabled: true
                opacity: 1
                focus: true
            }
            PropertyChanges {
                target: travelTimesBlur
                enabled: true
                opacity: 1
            }
            PropertyChanges {
                target: travelTimes
                enabled: false
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "x,y";
                easing.type: Easing.InOutQuad
                duration: 500
            }
        },
        Transition {
            to: "settings"
            PropertyAnimation {
                properties: "opacity";
                easing.type: Easing.InOutQuad
                duration: 250
            }
        },
        Transition {
            from: "settings"
            PropertyAnimation {
                properties: "opacity";
                easing.type: Easing.InOutQuad
                duration: 250
            }
        }
    ]

    Timer {
        id: timer
        repeat: true
        running: true
        onTriggered: {
            if(root.state == "showTravelTimes") {
                root.state = "showCpuStats"
            } else if(root.state == "showCpuStats") {
                root.state = "showMemoryStats"
            } else if(root.state == "showMemoryStats") {
                root.state = "showTravelTimes"
            }
        }
    }
}
