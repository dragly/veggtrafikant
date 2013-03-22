import QtQuick 2.0

Rectangle {
    id: root

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
        interval: 2000
        onTriggered: {
            refresh()
        }
    }

    Text {
        text: "CPU usage"
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
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.margins: 16
        clip: true
        focus: true
        model: cpuModel
        delegate: Item {
            width: view.width
            height: view.height / 10
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
            gradient.addColorStop(0.0, Qt.rgba(1.0, 1.0, 1.0, 0.0))
            gradient.addColorStop(1.0, Qt.rgba(0.0, 0.0, 0.0, 0.3))
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
        var url = "http://compphys.dragly.org/wp-content/plugins/cpu-reporter/results.php?timeLimit=600&type=cpu&latest=1";
        console.log(url)
        xhr.open("GET", url);
        var letters = '0123456789ABCDEF'.split('');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                cpuModel.clear()

                var a = JSON.parse(xhr.responseText);
                var counter = 0;
                for (var b in a) {
                    var o = a[b]
                    for(var c in o) {
                        var o2 = o[c]
                        var color = "#";
                        var rNum = Math.round(parseFloat(o2.y) / 100 * 15);
                        color += letters[rNum];
                        color += "0";
                        color += letters[15 - rNum];
                        color += "0";
                        color += "77"
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
