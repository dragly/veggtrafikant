var latestRequestedURL = ""

function findStations(searchText, realtime, searchModel) {
    if(searchText === "") {
        return;
    }

    var xhr = new XMLHttpRequest;
    var url
    url = "http://reisapi.ruter.no/Place/GetPlaces/" +  searchText + "?json=true"
    latestRequestedURL = url;
    xhr.open("GET", url);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE && latestRequestedURL === url) {
            try {
                var stops = JSON.parse(xhr.responseText);
                searchModel.clear()
                for (var stopi in stops) {
                    var stop = stops[stopi];
                    if(stop.PlaceType === "Stop") { // we only accept stops
                        searchModel.append({name: stop.Name, stationID: stop.ID});
                        var lines = stop.Lines;
                        for(var linei in lines) {
                            var line = lines[linei];
                            console.log(line.Name);
                        }
                    }
                }
                searchModel.loadCompleted()
            } catch (error) {
                console.log("Could not parse JSON response from " + url)
            }
        }
    }
    xhr.send();
}
