// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "constants.js" as UI
import "helpers.js" as Helper

Rectangle {
    id: root

    property real defaultMargin: UI.MARGIN_XLARGE
    property string stationName
    property string stationId: "3010420"
    width: 360
    height: 360
    color: "black"

    Timer {
        id: refreshRealtime
        triggeredOnStart: true
        repeat: true
        running: true
        interval: 30000
        onTriggered: {
            refresh()
        }
    }

    Timer {
        id: refreshWeather
        triggeredOnStart: true
        repeat: true
        running: true
        interval: 30 * 60 * 1000
        onTriggered: {
            weatherModel.reload()
        }
    }

    Timer {
        id: refreshClock
        triggeredOnStart: true
        repeat: true
        running: true
        interval: 60 * 1000
        onTriggered: {
            clockText.text = Qt.formatDateTime(new Date(), "hh:mm")
        }
    }

    ListModel {
        id: realtimeModel

        signal loadCompleted()
    }

    Item {
        anchors {
            fill: parent
            margins: parent.height * 0.01
        }
        Item {
            id: weatherRow
            anchors.top: parent.top
            width: parent.width
            height: root.height * 0.15
            Text {
                id: clockText

                font.pixelSize: parent.height * 0.8
                anchors.left: parent.left

                text: "Clock"
                color: "white"
            }
            Text {
                id: weatherText

                font.pixelSize: parent.height * 0.8
                anchors.right: parent.right

                text: "Weather"
                color: "white"
            }
            Image {
                id: weatherImage
                source: "qrc:images/yr/1.png"

                anchors.right: weatherText.left
                height: parent.height
                width: parent.height
                fillMode: Image.PreserveAspectFit
            }
        }
        ListView {
            id: listview

            anchors {
                bottom: parent.bottom
                top: weatherRow.bottom
                right: parent.right
                left: parent.left
                rightMargin: parent.height * 0.05
                leftMargin: parent.height * 0.05
                topMargin: parent.height * 0.02
            }
            interactive: true
            clip: true

            header: Column {
                id: col
                spacing: defaultMargin
                width: parent.width
            }

            model: realtimeModel
            delegate: ListDelegate {
                titleSize: root.height * 0.08
                subtitleSize: root.height * 0.06
                onClicked:  {}
            }

            MouseArea {
                anchors.fill: parent
                onClicked: refresh()
            }

        }
    }

    XmlListModel {
        id: weatherModel
        source: "http://www.yr.no/sted/Norge/Oslo/Oslo/Oslo/varsel.xml"
        query: "/weatherdata/forecast/tabular/time"

        XmlRole { name: "symbolNumber"; query: "symbol/@number/string()" }
        XmlRole { name: "symbolName"; query: "symbol/@name/string()" }
        XmlRole { name: "temperature"; query: "temperature/@value/string()" }
        onStatusChanged: {
            console.log("Status is: " + weatherModel.status)
            if(status == XmlListModel.Error) {
                console.log("Error: " + weatherModel.errorString)
            }
            if(status == XmlListModel.Ready) {
                console.log("First role: " + weatherModel.get(0).symbolName)
                weatherText.text = weatherModel.get(0).temperature + "°C"
                weatherImage.source = "qrc:images/yr/" + weatherModel.get(0).symbolNumber + ".png"
            }
            console.log("Count is: " + weatherModel.count)
        }
    }

    function refresh() {
        var counter = 0
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "http://services.epi.trafikanten.no/RealTime/GetRealTimeData/" +  stationId);
        console.log("http://services.epi.trafikanten.no/RealTime/GetRealTimeData/" +  stationId)
        xhr.onreadystatechange = function() {
                    if (xhr.readyState == XMLHttpRequest.DONE) {
                        realtimeModel.clear()
                        var a = JSON.parse(xhr.responseText);
                        for (var b in a) {
                            if(counter < 8) {
                                var o = a[b]
                                var substrLength = o.ExpectedArrivalTime.indexOf("+")-6
                                var arrivalTime = Helper.parseDate(o.ExpectedArrivalTime)
                                var currentTime = Helper.parseDate(o.RecordedAtTime)
                                var timeDifference = arrivalTime.getTime() - currentTime.getTime()
                                var timeDifferenceMinutes = timeDifference / 60000
                                realtimeModel.append({
                                                         title: o.PublishedLineName + " " + o.DestinationName,
                                                         arrivalTime: arrivalTime,
                                                         timeLeft: timeDifferenceMinutes.toFixed(0) + " min",
                                                         subtitle: Qt.formatDateTime(arrivalTime, "hh:mm"),
                                                         platform: o.DirectionRef,
                                                         selected: false
                                                     });
                                console.log(o.PublishedLineName + " " + o.DestinationName + " " + timeDifferenceMinutes.toFixed(0) + " min")
                            }
                            counter++
                        }
                        var swapped = true; // let's perform a bubble sort! :D
                        while(swapped) {
                            swapped = false;
                            for(var i = 0; i < realtimeModel.count - 1; i++) {
                                if(realtimeModel.get(i).arrivalTime > realtimeModel.get(i + 1).arrivalTime) {
                                    realtimeModel.move(i,i+1,1);
                                    swapped = true;
                                }
                            }
                        }
                        realtimeModel.loadCompleted()
                    }
                }
        xhr.send();
        counter = 0
    }
}
