// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "constants.js" as UI
import "helpers.js" as Helper

Rectangle {
    property real defaultMargin: UI.MARGIN_XLARGE
    property string stationName
    property string stationId: "3010420"
    width: 360
    height: 360
    color: "black"

    Timer {
        triggeredOnStart: true
        running: true
        interval: 60000
        onTriggered: refresh()
    }

    ListModel {
        id: realtimeModel

        signal loadCompleted()
    }

    ListView {
        id: listview
        interactive: true
        anchors.fill: parent
        anchors.margins: 20

        header: Column {
            id: col
            spacing: defaultMargin
            width: parent.width

            Text {
                text: stationName
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: UI.LIST_TILE_SIZE + 4
            }
        }

        model: realtimeModel
        delegate: ListDelegate {
            onClicked:  {}
            Text {
                id: timeText
                text: model.timeLeft
                font.weight: Font.Bold
                font.pixelSize: UI.LIST_TILE_SIZE
                color: UI.LIST_TITLE_COLOR_INVERTED
                anchors.right: parent.right

                anchors.verticalCenter: parent.verticalCenter
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: refresh()
    }

    function refresh() {
        realtimeModel.clear()

        var xhr = new XMLHttpRequest;
        xhr.open("GET", "http://services.epi.trafikanten.no/RealTime/GetRealTimeData/" +  stationId);
        console.log("http://services.epi.trafikanten.no/RealTime/GetRealTimeData/" +  stationId)
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                var a = JSON.parse(xhr.responseText);
                for (var b in a) {
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
                                         subtitle: Qt.formatDateTime(arrivalTime, "yyyy-MM-dd hh:mm:ss"),
                                         platform: o.DirectionRef,
                                         selected: false
                });
                    console.log(o.PublishedLineName + " " + o.DestinationName + " " + timeDifferenceMinutes.toFixed(0) + " min")
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
    }
}
