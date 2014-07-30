import QtQuick 2.0
import QtGraphicalEffects 1.0
import org.dragly.veggtrafikant 1.0

Rectangle {
    id: root

    property Style theme: Style {}

    width: 800
    height: 600
    smooth: true
    focus: true

    state: ""

    Timer {
        id: refreshTheme
        triggeredOnStart: true
        repeat: true
        running: true
        interval: 60 * 1000
        onTriggered: {
            var hour = parseInt(Qt.formatDateTime(new Date(), "hh"))
            if(hour > 7 && hour < 21) {
                theme = dayTheme
            } else {
                theme = nightTheme
            }
        }
    }

    Style {
        id: dayTheme
        background: Gradient {
            GradientStop{ position: 0.0; color: "#71CBF6" }
            GradientStop{ position: 0.2; color: "#71CBF6" }
            GradientStop{ position: 0.8; color: "#0578AF" }
        }
        highlight: "#84D7FF"
        headings: "#0578AF"
        textHighlight: "#E6F7FF"
        text: "#002334"
        travelText: "#E6F7FF"

        strongBack: "#08306b"
        duseBack: "#2171b5"
        middle: "#6baed6"
        duseFront: "#c6dbef"
        strongFront: "#f7fbff"
    }

    Style {
        id: nightTheme
        text: "#0000FF"

        background: Gradient {
            GradientStop{ position: 0.75; color: "#023858" }
            GradientStop{ position: 0.95; color: "#045a8d" }
            GradientStop{ position: 1.0; color: "#0570b0" }
        }
        travelText: "#E6F7FF"

        duseBack: "#045a8d"
        strongBack: "#023858"
        middle: "#74a9cf"
        duseFront: "#ece7f2"
        strongFront: "#fff7fb"
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Q && event.modifiers & Qt.ControlModifier) {
            Qt.quit()
        }
        if(event.key === Qt.Key_Escape) {
            state = "settings"
            event.accepted = true
        }
    }

    SystemPalette {
        id: sysPalette
        colorGroup: SystemPalette.Active
    }

    gradient: theme.background

    TravelTimes {
        id: travelTimes
        x: 0
        y: 0
        width: parent.width
        height: parent.height
    }

    FastBlur {
        id: travelTimesBlur
        anchors.fill: parent
        source: travelTimes
        radius: parent.width / 12
//        samples: 8
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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.state = "settings"
        }
    }
}
