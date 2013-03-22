import QtQuick 2.0

Rectangle {
    id: root

    width: 480
    height: 480
    smooth: true
    //    color: "black"
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

    CpuStats {
        anchors.left: travelTimes.right
        anchors.top: travelTimes.top

        width: parent.width
        height: parent.height
    }

    states: [
        State {
            name: "showTravelTimes"
            PropertyChanges {
                target: travelTimes
                x: 0
            }
        },
        State {
            name: "showCpuStats"
            PropertyChanges {
                target: travelTimes
                x: -parent.width
            }
        }
    ]

    state: "showCpuStats"

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "x,y";
                easing.type: Easing.InOutQuad
                duration: 500
            }
        }
    ]

    Timer {
        repeat: true
        running: true
        interval: 10 * 1000
        onTriggered: {
            if(root.state == "showTravelTimes") {
                root.state = "showCpuStats"
            } else {
                root.state = "showTravelTimes"
            }
        }
    }
}
