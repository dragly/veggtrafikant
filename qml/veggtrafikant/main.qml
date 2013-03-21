// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "constants.js" as UI
import "helpers.js" as Helper

Rectangle {
    id: root

    property real defaultMargin: UI.MARGIN_XLARGE
    property string stationName
    property variant stations: [
        {stationId: "3011610", directions: ["2"], maxTime: 8},
        {stationId: "3011612", directions: ["2"], maxTime: 4}
    ]
    property int newsId: 0
    property int nDepartures: 7

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

    Timer {
        id: refreshNews
        triggeredOnStart: true
        repeat: true
        running: true
        interval: 10 * 60 * 1000
        onTriggered: {
            newsModel.reload()
        }
    }

    Timer {
        id: switchNews
        triggeredOnStart: true
        repeat: true
        interval: 10 * 1000
        onTriggered: {
            if(newsText.anchors.bottomMargin == 0) {
                newsAnimation.start()
                interval = 1000
            } else {
                if(newsModel.count > 0) {
                    newsId++
                    if(newsId >= newsModel.count) {
                        newsId = 0
                    }
                    newsText.text = newsModel.get(newsId).title + ": " + newsModel.get(newsId).description
                }
                newsAnimationBack.start()
                interval = 10 * 1000
            }
        }
    }

    PropertyAnimation {
        id: newsAnimation
        target: newsText
        property: "anchors.bottomMargin"
        to: -2 * newsText.height
        easing.type: Easing.InBack
        duration: 500
    }
    PropertyAnimation {
        id: newsAnimationBack
        target: newsText
        property: "anchors.bottomMargin"
        to: 0
        easing.type: Easing.OutBack
        duration: 500
    }

    //    Timer {
    //        id: rollNews
    //        triggeredOnStart: true
    //        repeat: true
    //        running: false
    //        interval: 60 * 1000
    //        onTriggered: {
    //            newsText.anchors.leftMargin = root.width
    //            newsAnimation.start()
    //        }
    //    }

    //    PropertyAnimation {
    //        id: newsAnimation
    //        target: newsText
    //        property: "anchors.leftMargin"
    //        to: -root.width * 10
    //        duration: rollNews.interval * 0.8
    //    }

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
            height: root.height * 0.12
            Text {
                id: clockText

                font.pixelSize: parent.height * 0.8
                anchors.left: parent.left

                text: "Clock"
                color: "white"
            }
            Text {
                id: weatherText

                font.pixelSize: parent.height * 0.7
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                text: "Weather"
                color: "white"
            }
            Image {
                id: weatherImage
                source: "qrc:images/yr/1.png"

                anchors.right: weatherText.left
                anchors.rightMargin: root.height * 0.03
                height: parent.height
                width: parent.height
                fillMode: Image.PreserveAspectFit
            }
        }
        ListView {
            id: listview

            anchors {
                bottom: newsText.top
                top: weatherRow.bottom
                right: parent.right
                left: parent.left
                rightMargin: parent.height * 0.05
                leftMargin: parent.height * 0.05
                topMargin: parent.height * 0.01
            }

            header: Column {
                id: col
                spacing: defaultMargin
                width: parent.width
            }

            model: realtimeModel
            delegate: ListDelegate {
                titleSize: root.height * 0.08
                subtitleSize: root.height * 0.07
            }

        }
        Text {
            id: newsText
            text: "Updating news..."
            color: "white"
            height: root.height * 0.18
            font.pixelSize: root.height * 0.038
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin: root.height * 0.01
                rightMargin: root.height * 0.01
            }
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignTop
            clip: true
        }
    }

    XmlListModel {
        id: newsModel
        source: "http://www.nrk.no/nyheiter/siste.rss"
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        onStatusChanged: {
            if(status == XmlListModel.Error) {
                console.log("News error: " + weatherModel.errorString)
            } else if(status == XmlListModel.Ready) {
                switchNews.start()
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
            if(status == XmlListModel.Error) {
                console.log("Yr.no error: " + weatherModel.errorString)
            }
            if(status == XmlListModel.Ready) {
                weatherText.text = weatherModel.get(0).temperature + "°C"
                weatherImage.source = "qrc:images/yr/" + weatherModel.get(0).symbolNumber + ".png"
            }
        }
    }

    property int stationIdCounter: 0;
    property bool isRealtimeModelCleared: false;
    function refresh() {
        var colorList = ["rgb(255,255,150)", "rgb(255,180,150)", "rgb(255,255,255)"]
        if(stationIdCounter < stations.length) {
            var stationId = stations[stationIdCounter].stationId
            var directions = stations[stationIdCounter].directions
            var maxTime = stations[stationIdCounter].maxTime
            console.log(stationIdCounter)
            console.log(stationId)
            var xhr = new XMLHttpRequest;
            xhr.open("GET", "http://services.epi.trafikanten.no/RealTime/GetRealTimeData/" +  stationId);
            console.log("http://services.epi.trafikanten.no/RealTime/GetRealTimeData/" +  stationId)
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if(stationIdCounter == 0) {
                        realtimeModel.clear();
                    }

                    var a = JSON.parse(xhr.responseText);
                    if(!isRealtimeModelCleared) {
                        realtimeModel.clear();
                        isRealtimeModelCleared = 1;
                    }

                    for (var b in a) {
//                        if(counter < nDepartures) {
                            var o = a[b]
                                var substrLength = o.ExpectedArrivalTime.indexOf("+")-6
                                var arrivalTime = Helper.parseDate(o.ExpectedArrivalTime)
                                var currentTime = Helper.parseDate(o.RecordedAtTime)
                                var timeDifference = arrivalTime.getTime() - currentTime.getTime()
                                var timeDifferenceMinutes = timeDifference / 60000
                                if(directions.indexOf(o.DirectionName) !== -1 && timeDifferenceMinutes > maxTime) {
                                realtimeModel.append({
                                                         lineNumber: o.PublishedLineName,
                                                         title: o.PublishedLineName + " " + o.DestinationName,
                                                         arrivalTime: arrivalTime,
                                                         timeLeft: timeDifferenceMinutes.toFixed(0) + " min",
                                                         subtitle: Qt.formatDateTime(arrivalTime, "hh:mm"),
                                                         platform: o.DirectionRef,
                                                         selected: false
                                                     });
                                console.log("Added")
                            }
                            console.log(o.PublishedLineName + " " + o.DestinationName + " " + timeDifferenceMinutes.toFixed(0) + " min")
//                        }
//                        counter++
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
                    stationIdCounter++;
                    refresh();
                }
            }
            xhr.send();
        } else {
            stationIdCounter = 0;

            while(realtimeModel.count > nDepartures) {
                realtimeModel.remove(realtimeModel.count - 1);
            }
            realtimeModel.loadCompleted()
        }
    }
}
