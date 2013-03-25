import QtQuick 2.0

Rectangle {
    id: root

    property string url: "http://compphys.dragly.org/wp-content/plugins/cpu-reporter/results.php?timeLimit=600&type=cpu&latest=1"
    property string title: "CPU usage"
    property int updateInterval: 60000

    width: 100
    height: 62
    color: "transparent"

    Component.onCompleted: {
        refresh()
    }

    ListModel
    {
        id: cpuModel
        function loadCompleted() {
            canvas.requestPaint()
        }
    }

    Timer {
        repeat: true
        running: true
        interval: updateInterval
        onTriggered: {
            refresh()
        }
    }

    Text {
        text: root.title
        font.pixelSize: parent.height * 0.05
        anchors {
            top: parent.top
            left: parent.left
            margins: parent.width * 0.01
        }
        color: "white"
    }

    ListView {
        id: view
        anchors.verticalCenter: parent.verticalCenter
        height: cpuModel.count * root.height / 10
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.margins: 16
        clip: true
        focus: true
        model: cpuModel
        delegate: Item {
            width: view.width
            height: root.height / 10
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 2
                color: model.color
                //                border.color: Qt.lighter(root.color)
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 8
                text: model.label
                color: "white"
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.margins: 8
                text: Math.round(model.value, 0)
                color: "white"
            }

        }
    }


    Canvas {
        id: canvas
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: view.left
        // enable anti-aliasing
        smooth: true
        onPaint: {
            console.log(cpuModel.count)
            console.log(modelSum())
            var ctx = canvas.getContext('2d')
            ctx.clearRect(0, 0, width, height)
            // store the circles properties
            var centerX = width / 2
            var centerY = height / 2
            var radius = 0.9 * Math.min(width, height) / 2
            var radiusFactor = 1.0
            var startAngle = 0.0
            var endAngle = 0.0
            var angleFactor = 2 * Math.PI / modelSum()
            ctx.lineWidth = 2
            ctx.strokeStyle = Qt.lighter(root.color)
            for (var index = 0; index < cpuModel.count; index++) {
                startAngle = endAngle
                endAngle = startAngle + cpuModel.get(index).value * angleFactor
                // scale the currently selected piece and
                // rotate the canvas element accordingly
                radiusFactor = 1.0
                ctx.fillStyle = cpuModel.get(index).color
                ctx.beginPath()
                ctx.moveTo(centerX, centerY)
                ctx.arc(centerX, centerY, radius * radiusFactor,
                        startAngle, endAngle, false)
                ctx.lineTo(centerX, centerY)
                ctx.fill()
                ctx.stroke()
            }
            // overlay a radial gradient
            var gradient = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, radius)
            gradient.addColorStop(0.0, Qt.rgba(1.0, 1.0, 1.0, 0.1))
            gradient.addColorStop(0.5, Qt.rgba(0.5, 0.5, 0.5, 0.0))
            gradient.addColorStop(1.0, Qt.rgba(0.0, 0.0, 0.0, 0.1))
            ctx.beginPath()
            ctx.moveTo(centerX, centerY)
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false)
            ctx.fillStyle = gradient
            ctx.fill()

        }
    }
    //    function colorByPercentage(percentage) {
    //        var letters = '0123456789ABCDEF'.split('');
    //        var color = '#';
    //        for (var i = 0; i < 6; i++ ) {
    //            color += letters[Math.round(percentage * 15)];
    //        }
    //        return color;
    //    }
    // calculate the model’s sum of values
    function modelSum() {
        var modelSum = 0
        for (var index = 0; index < cpuModel.count; index++) {
            modelSum += cpuModel.get(index).value
        }
        return modelSum
    }
    function refresh() {
        console.log("Wee!")
        //                realtimeModel.clear()

        var xhr = new XMLHttpRequest;
        console.log(root.url)
        xhr.open("GET", root.url);
        var colors = new Array;
        colors[0] = "#FF9A40";
        colors[1] = "#AC3BD4";
        colors[2] = "#B4BD2F";
        colors[3] = "#35C0CD";
        colors[4] = "#FF4540";
        colors[5] = "#7147D7";
        colors[6] = "#FFE240";
        colors[7] = "#39E444";
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                cpuModel.clear()

                var a = JSON.parse(xhr.responseText);
                var counter = 0;
                for (var b in a) {
                    var o = a[b]
                    for(var c in o) {
                        var o2 = o[c]
                        var color = colors[counter % colors.length];
                        console.log(color)
                        cpuModel.append({
                                            value: parseFloat(o2.y),
                                            label: b,
                                            color: color
                                        })
                    }
                    counter++;
                }
                cpuModel.loadCompleted()
            }
        }
        xhr.send();
    }
}
