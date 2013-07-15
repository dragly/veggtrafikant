import QtQuick 2.0
import QtGraphicalEffects 1.0
import org.dragly.veggtrafikant 1.0

Rectangle {
    id: root

    width: 480
    height: 480
    smooth: true
    focus: true

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

    SettingsStorage {
        Component.onCompleted: {
            setValue("stations", [{woot: "cookie", test: "banana"}, {woot: "lol", test: "apple"}])
            console.log(value("stations")[0].woot)
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
        }
    }

    //    CpuStats {
    //        id: cpuStats
    //        url: "http://comp-phys.net/wp-content/plugins/cpu-reporter/results.php?timeLimit=600&type=cpu&latest=1"
    //        title: "CPU usage"
    //        anchors.left: travelTimes.right
    //        anchors.top: travelTimes.top

    //        width: parent.width
    //        height: parent.height
    //    }

    //    CpuStats {
    //        id: memoryStats
    //        title: "Memory usage"
    //        url: "http://comp-phys.net/wp-content/plugins/cpu-reporter/results.php?timeLimit=600&type=memory&latest=1"
    //        anchors.left: cpuStats.right
    //        anchors.top: cpuStats.top

    //        width: parent.width
    //        height: parent.height
    //    }

    //    states: [
    //        State {
    //            name: "showTravelTimes"
    //            PropertyChanges {
    //                target: children[0]
    //                x: 0
    //            }
    //            PropertyChanges {
    //                target: timer
    //                interval: 30 * 1000
    //            }
    //        },
    //        State {
    //            name: "showCpuStats"
    //            PropertyChanges {
    //                target: children[0]
    //                x: -parent.width
    //            }
    //            PropertyChanges {
    //                target: timer
    //                interval: 7 * 1000
    //            }
    //        },
    //        State {
    //            name: "showMemoryStats"
    //            PropertyChanges {
    //                target: children[0]
    //                x: -parent.width * 2
    //            }
    //            PropertyChanges {
    //                target: timer
    //                interval: 7 * 1000
    //            }
    //        }
    //    ]

    //    state: "showTravelTimes"

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

    Keys.onPressed: {
        if(event.key === Qt.Key_Q && event.modifiers & Qt.ControlModifier) {
            Qt.quit()
        }
        if(event.key === Qt.Key_Escape) {
            state = "settings"
//            showSettings()
        }
    }

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
