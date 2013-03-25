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
        id: cpuStats
        url: "http://compphys.dragly.org/wp-content/plugins/cpu-reporter/results.php?timeLimit=600&type=cpu&latest=1"
        title: "CPU usage"
        anchors.left: travelTimes.right
        anchors.top: travelTimes.top

        width: parent.width
        height: parent.height
    }

    CpuStats {
        id: memoryStats
        title: "Memory usage"
        url: "http://compphys.dragly.org/wp-content/plugins/cpu-reporter/results.php?timeLimit=600&type=memory&latest=1"
        anchors.left: cpuStats.right
        anchors.top: cpuStats.top

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
            PropertyChanges {
                target: timer
                interval: 30 * 1000
            }
        },
        State {
            name: "showCpuStats"
            PropertyChanges {
                target: travelTimes
                x: -parent.width
            }
            PropertyChanges {
                target: timer
                interval: 7 * 1000
            }
        },
        State {
            name: "showMemoryStats"
            PropertyChanges {
                target: travelTimes
                x: -parent.width * 2
            }
            PropertyChanges {
                target: timer
                interval: 7 * 1000
            }
        }
    ]

    state: "showTravelTimes"

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
