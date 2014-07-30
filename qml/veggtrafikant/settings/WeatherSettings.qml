import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.dragly.veggtrafikant 1.0

Item {
    id: weatherSettingsRoot

    property var placeNames: []

    focus: true

    Component.onCompleted: {
        currentLocationText.text = settingsStorage.value("yrPlaceName", "Oslo")
        loadPlaces()
    }

    onActiveFocusChanged: {
        if(activeFocus) {
            locationTextEdit.focus = true
        }
    }

    function loadPlaces() {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                allWeatherPlaceModel.clear()
                console.log("Splitting lines in file")
                var lines = xhr.responseText.split("\n")
                for(var i = 0; i < lines.length - 1; i++) {
                    var line = lines[i + 1]
                    var tabs = line.split("\t")
                    var placeName = tabs[1]
                    if(!placeName || placeName === undefined) {
                        continue
                    }
                    var kommune = tabs[6]
                    var fylke = tabs[7]
                    var link = tabs[12]
                    var weatherPlace = {placeName: placeName, fylke: fylke, kommune: kommune, link: link}
                    allWeatherPlaceModel.append(weatherPlace)
                    placeNames.push("" + i + "," + placeName.toLowerCase() + fylke.toLowerCase() + kommune.toLowerCase())
                }
                console.log(allWeatherPlaceModel.count + " places loaded")
            }
        }
        xhr.open("GET", "../weather/noreg.txt")
        xhr.send()
    }

    function filterPlaces(searchString) {
        weatherPlaceListView.showHighlight = false
        weatherPlaceModel.clear()
        searchString = searchString.replace(/[,;\.]/g, "")
        var searchTerms = searchString.split(" ")
        var lowerCaseSearchTerms = []
        for(var i = 0; i < searchTerms.length; i++) {
            var searchTerm = searchTerms[i].toLowerCase()
            lowerCaseSearchTerms.push(searchTerm)
        }

        var resultCount = 0
        var results = placeNames.filter(function(placeName) {
            if(resultCount > 200) {
                return false;
            }

            var found = true
            for(var j = 0; j < lowerCaseSearchTerms.length && found; j++) {
                var termFound = false
                var searchTerm = lowerCaseSearchTerms[j]
                if(placeName.toLowerCase().indexOf(searchTerm) > -1) {
                    termFound = true
                }
                if(!termFound) {
                    found = false
                }
            }
            if(found) {
                resultCount += 1
            }
            return found
        })
        for(var i = 0; i < results.length; i++) {
            var index = parseInt(results[i].split(",")[0])
            var weatherPlace = allWeatherPlaceModel.get(index)
            weatherPlaceModel.append(weatherPlace)
        }
    }

    SettingsStorage {
        id: settingsStorage
    }

    ListModel {
        id: allWeatherPlaceModel
    }

    ListModel {
        id: weatherPlaceModel
    }

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: weatherSettingsRoot.width * 0.05
        spacing: weatherSettingsRoot.width * 0.05
        SettingsHeading {
            text: qsTr("Weather location")
        }
        Text {
            id: currentLocationText
            text: ""
            font.pixelSize: parent.width * 0.04
            color: theme.duseFront
        }
        TextField {
            id: locationTextEdit

            inputMethodHints: Qt.ImhNoPredictiveText
            width: parent.width
            Layout.fillWidth: true
            font.pixelSize: weatherSettingsRoot.width * 0.04
            placeholderText: "Search..."

            onTextChanged: {
                filterPlaces(locationTextEdit.text)
            }
        }
        Item {
            width: weatherSettingsRoot.width
            Layout.fillHeight: true
            Layout.fillWidth: true
            SettingsListViewBackground {
                anchors.fill: weatherPlaceListView
            }

            ListView {
                id: weatherPlaceListView
                property bool showHighlight
                clip: true
                cacheBuffer: 100
                model: weatherPlaceModel
                anchors.fill: parent
                contentHeight: weatherSettingsRoot.width * 0.1 * count
                boundsBehavior: Flickable.StopAtBounds
                delegate: Item {
                    id: delegateItem
                    width: weatherPlaceListView.width
                    height: weatherPlaceListView.width * 0.1

                    Rectangle {
                        id: lineRect
                        anchors {
                            bottom: parent.bottom
                            left: placeText.left
                            right: parent.right
                        }
                        height: 2
                        color: theme.middle
                        visible: index < weatherPlaceListView.model.count - 1
                    }
                    Text {
                        id: placeText
                        anchors {
                            left: parent.left
                            leftMargin: parent.width * 0.05
                            verticalCenter: parent.verticalCenter
                        }
                        text: model.placeName
                        font.pixelSize: delegateItem.height * 0.4
                        color: theme.strongFront
                        font.weight: Font.Light
                    }
                    Text {
                        id: placeFylkeText
                        anchors {
                            rightMargin: parent.width * 0.05
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        text: model.kommune + ", " + model.fylke
                        font.pixelSize: delegateItem.height * 0.3
                        color: theme.duseFront
                        font.weight: Font.Light
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.inputMethod.hide()
                            weatherPlaceListView.forceActiveFocus()
                            settingsStorage.setValue("yrLink", model.link)
                            settingsStorage.setValue("yrPlaceName", model.placeName + ", " + model.kommune + ", " + model.fylke)
                            currentLocationText.text = settingsStorage.value("yrPlaceName", "Oslo")
                            weatherPlaceListView.currentIndex = index
                            weatherPlaceListView.showHighlight = true
                        }
                    }
                }
                highlight: Rectangle {
                    width: weatherPlaceListView.width
                    height: weatherPlaceListView.width * 0.1
                    opacity: weatherPlaceListView.showHighlight ? 0.1 : 0.0
                    color: "white"
                }
            }
        }
    }
}

