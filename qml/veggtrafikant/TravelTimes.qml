// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import org.dragly.veggtrafikant 1.0
import "constants.js" as UI
import "helpers.js" as Helper

Item {
    id: root

    property real defaultMargin: UI.MARGIN_XLARGE
    property string stationName
    //    property variant stations: []
    property int nDepartures: 6
    property int currentStationID: 0;
    property bool isRealtimeModelCleared: false;
    property string yrLocationString: ""

    smooth: true
//    color: "transparent"

    function refresh() {
        reloadWeather()
        reloadFeed()
        reloadTravelTimes()
    }

    function reloadTravelTimes() {
        currentStationID =  0
        loadTravelTimesForNextStation()
    }

    function loadTravelTimesForNextStation() {
        var stations = settingsStorage.value("stations")
        if(!stations) {
            return;
        }

        var colorList = ["rgb(255,255,150)", "rgb(255,180,150)", "rgb(255,255,255)"]
        if(currentStationID < stations.length) {
            var stationID = stations[currentStationID].stationID
            var xhr = new XMLHttpRequest;
            var url = "http://reisapi.ruter.no/StopVisit/GetDepartures/" +  stationID;
            console.log("Fetching data for station " + stations[currentStationID].name)
            xhr.open("GET", url);
            xhr.stationIDCounter = currentStationID
            xhr.station = stations[currentStationID]
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if(currentStationID !== xhr.stationIDCounter) {
                        return
                    }
                    parseTravelTimes(xhr.responseText, xhr.station)
                    currentStationID += 1
                    loadTravelTimesForNextStation()
                }
            }
            xhr.send();
        } else {
            currentStationID = 0;

            finalRealtimeModel.clear()
            for(var i = 0; i < realtimeModel.count; i++) {
                finalRealtimeModel.append(realtimeModel.get(i))
            }
            realtimeModel.clear()
            var swapped = true; // let's perform a bubble sort! :D
            while(swapped) {
                swapped = false;
                for(var i = 0; i < finalRealtimeModel.count - 1; i++) {
                    if(finalRealtimeModel.get(i).arrivalTime > finalRealtimeModel.get(i + 1).arrivalTime) {
                        finalRealtimeModel.move(i,i+1,1);
                        swapped = true;
                    }
                }
            }
            while(finalRealtimeModel.count > nDepartures) {
                finalRealtimeModel.remove(finalRealtimeModel.count - 1);
            }
        }
    }

    function parseTravelTimes(json, station) {
        var directionsString = station.directions
        var directions = directionsString.split(",")
        if(!directions || directions[0] === "" || directions[0] === "all") {
            directions = []
        }

        var minTime = station.minTime

        var a = JSON.parse(json);
        for (var b in a) {
            //                        if(counter < nDepartures) {
            var o = a[b]
            var journey = o.MonitoredVehicleJourney;
            var monitoredCall = journey.MonitoredCall;
            var substrLength = monitoredCall.ExpectedArrivalTime.indexOf("+")-6
            var arrivalTime = Helper.parseDate(monitoredCall.ExpectedArrivalTime)
            var currentTime = Helper.parseDate(o.RecordedAtTime)
            var timeDifference = arrivalTime.getTime() - currentTime.getTime()
            var timeDifferenceMinutes = timeDifference / 60000
            if(timeDifferenceMinutes > 120) {
                continue;
            }

            var identifier = "" + journey.LineRef + journey.DestinationRef
            if((directions.length === 0 || directions.indexOf(identifier) !== -1) && timeDifferenceMinutes >= minTime) {
                var dataItem = {
                    lineNumber: journey.PublishedLineName,
                    title: journey.PublishedLineName + " " + journey.DestinationName,
                    arrivalTime: arrivalTime,
                    timeLeft: timeDifferenceMinutes.toFixed(0) + " min",
                    subtitle: Qt.formatDateTime(arrivalTime, "hh:mm"),
                    platform: journey.DirectionRef,
                    selected: false
                };
                realtimeModel.append(dataItem);
            }
        }
    }

    function reloadWeather() {
        yrLocationString = settingsStorage.value("yrLink", "http://www.yr.no/stad/Noreg/Oslo/Oslo/Oslo/varsel.xml")
        weatherModel.reload()
    }

    function reloadFeed() {
        news.feedUrl = settingsStorage.value("feedURL", "http://www.nrk.no/nyheter/siste.rss")
        news.reload()
    }

    SettingsStorage {
        id: settingsStorage
    }

    Timer {
        id: refreshTravelTimes
        triggeredOnStart: true
        repeat: true
        running: true
        interval: 60 * 1000
        onTriggered: {
            reloadTravelTimes()
        }
    }

    Timer {
        id: refreshWeather
        triggeredOnStart: true
        repeat: true
        running: true
        interval: 30 * 60 * 1000
        onTriggered: {
            reloadWeather()
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
            reloadFeed()
        }
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
    }

    ListModel {
        id: finalRealtimeModel
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
                font.weight: Font.Light
                anchors.left: parent.left

                text: "Clock"
                color: theme.travelText
            }
            Text {
                id: weatherText

                font.pixelSize: parent.height * 0.7
                font.weight: Font.Light
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                text: "Weather"
                color: theme.travelText
            }
            Image {
                id: weatherImage
                source: "images/yr/1.png"

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
                bottom: news.top
                top: weatherRow.bottom
                right: parent.right
                left: parent.left
                rightMargin: parent.height * 0.05
                leftMargin: parent.height * 0.05
                topMargin: parent.height * 0.03
            }

            header: Column {
                id: col
                spacing: defaultMargin
                width: parent.width
            }

            model: finalRealtimeModel
            delegate: ListDelegate {
                titleSize: root.height * 0.08
                subtitleSize: root.height * 0.07
            }
        }
        NewsItem {
            id: news
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin: root.height * 0.01
                rightMargin: root.height * 0.01
            }
            height: root.height * 0.18
        }
    }

    XmlListModel {
        id: weatherModel
        source: yrLocationString
        query: "/weatherdata/forecast/tabular/time"

        XmlRole { name: "symbolNumber"; query: "symbol/@number/string()" }
        XmlRole { name: "symbolName"; query: "symbol/@name/string()" }
        XmlRole { name: "temperature"; query: "temperature/@value/string()" }
        onStatusChanged: {
            if(status == XmlListModel.Error) {
                console.log("Yr.no error: " + weatherModel.errorString())
                weatherText.text = "Error"
            }
            if(status == XmlListModel.Ready) {
                if(weatherModel.get(0)) {
                    weatherText.text = weatherModel.get(0).temperature + "°C"
                    weatherImage.source = "images/yr/" + weatherModel.get(0).symbolNumber + ".png"
                } else {
                    weatherText.text = "Error"
                }
            }
        }
    }

//    XmlListModel {
//        id: weatherPlacesModel
//        source: "weather/noreg.txt"
//        onStatusChanged: {
//            if(status == XmlListModel.Error) {
//                console.log("Weather places error: " + weatherPlacesModel.errorString())
//            }
//            if(status == XmlListModel.Ready) {
//                var lines = weatherPlacesModel.xml.split("\n")
//                console.log(lines[0])
//            }
//        }
//    }


}
