import QtQuick 2.0
import "../JSONListModel/jsonpath.js" as JSONHelper

Item {
    property string stationID: ""
    property string json: ""
    property string _query: "$..MonitoredVehicleJourney"
    property bool ready: false

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    onStationIDChanged: {
        jsonModel.clear()
        var xhr = new XMLHttpRequest;
        var source = "http://reisapi.ruter.no/StopVisit/GetDepartures/" + stationID + "?json=true"
        xhr.open("GET", source);
        ready = false
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                json = xhr.responseText;
            }
        }
        xhr.send();
    }

    onJsonChanged: {
        var a = JSON.parse(json);
        var alreadyAdded = []
        for (var b in a) {
            var o = a[b]
            var journey = o.MonitoredVehicleJourney

            if(journey.DirectionRef !== null) {
                var identifier = "" + journey.LineRef + journey.DestinationRef
                if(alreadyAdded.indexOf(identifier) === -1) {
                    journey.switchChecked = true
                    jsonModel.append(journey)
                    alreadyAdded.push(identifier)
                }
            }
        }
        ready = true
    }
}
