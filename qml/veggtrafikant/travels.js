var latestRequestedURL = ""

function findStations(searchText, realtime, searchModel) {
//    console.log(searchText)

    var xhr = new XMLHttpRequest;
    var url
    if(realtime) {
        url = "http://services.epi.trafikanten.no/RealTime/FindMatches/" +  searchText
    } else {
        url = "http://services.epi.trafikanten.no/Place/FindMatches/" +  searchText
    }
    latestRequestedURL = url;
//    console.log("Requesting " + url)
    xhr.open("GET", url);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE && latestRequestedURL === url) {
            var a = JSON.parse(xhr.responseText);
            searchModel.clear()
            for (var b in a) {
                var o = a[b];
                if(o.Type === 0) // we don't want areas yet
                    searchModel.append({name: o.Name, stationID: o.ID});
//                console.log(o.ID)
            }

            searchModel.loadCompleted()
        }
    }
    xhr.send();
}
