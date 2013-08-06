import QtQuick 2.0
import org.dragly.veggtrafikant 1.0
import "../travels.js" as Travels

Item {
    id: timetableSettingsRoot

    focus: true

    Component.onCompleted: {
        var allStations = settingsStorage.value("stations", null)
        if(allStations === null) {
            console.log("No stations set!")
        } else {
            for(var i in allStations) {
                var station = allStations[i]
                stationsModel.append(station)
            }
        }
    }

    function saveStations() {
        var stations = []
        for(var i = 0; i < stationsModel.count; i++) {
            var s = stationsModel.get(i)
            var station = {name: s.name, stationID: s.stationID, minTime: s.minTime, directions: s.directions}
            stations.push(station)
        }
        settingsStorage.setValue("stations", stations)
    }

    function addStation(station) {
        stationsModel.append(station)
        saveStations()
    }

    onActiveFocusChanged: {
        if(activeFocus) {
            stationSelector.focus = true
        }
    }

    ListModel {
        id: stationsModel
    }

    SettingsStorage {
        id: settingsStorage
    }

    Column {
        id: stationColumn
        width: parent.width * 0.5
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        spacing: settingsRoot.height * 0.02
        SettingsHeading {
            text: qsTr("Selected stations")
            font.pixelSize: timetableSettingsRoot.width * 0.05
        }

        ListView {
            id: stationSelector

            width: parent.width
//            height: parent.height - addButton.height * 2
            height: timetableSettingsRoot.width * 0.1 * count
            model: stationsModel
            clip: true
            delegate: Text {
                id: delegateItem
                property variant myData: model
                width: stationSelector.width
                height: timetableSettingsRoot.width * 0.1
                Text {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: model.name
                    font.pixelSize: delegateItem.height * 0.5
                    font.weight: Font.Light
                    color: exitView.activeFocus && delegateItem.ListView.isCurrentItem ? "#EFEFEF" : "#00283B"

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }

            highlight: Rectangle {
                width: stationSelector.width
                height: stationSelector.width * 0.2
                color: stationSelector.activeFocus ? "#71CBF6" : "transparent"
            }

            KeyNavigation.down: addButton
            KeyNavigation.right: stationSettings

            onCurrentItemChanged: {
                if(currentIndex >= 0) {
                    stationSettings.minTime = currentItem.myData.minTime
                    stationSettings.directions = currentItem.myData.directions
                }
            }
        }

        Text {
            id: addButton
            font.pixelSize: timetableSettingsRoot.width * 0.04
            text: "Add"
            color: focus ? "white" : "grey"

            Keys.onPressed: {
                if(event.key === Qt.Key_Return) {
                    searchOverlay.enabled = true
                    searchOverlay.opacity = 1
                    searchOverlay.focus = true
                }
            }
        }
    }

    Item {
        id: stationSettings

        property alias minTime: minTimeTextEdit.text
        property alias directions: directionsTextEdit.text

        anchors {
            left: stationColumn.right
            leftMargin: parent.width * 0.02
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        visible: stationSelector.focus || stationSettings.focus || minTimeTextEdit.focus || directionsTextEdit.focus || deleteButton.focus

        KeyNavigation.left: stationSelector

        onFocusChanged: {
            if(focus) {
                minTimeTextEdit.focus = true
            }
        }

        Column {
            anchors.fill: parent
            spacing: timetableSettingsRoot.width * 0.01
            Row {
                spacing: timetableSettingsRoot.width * 0.01
                Text {
                    text: "Min. time:"
                    font.pixelSize: timetableSettingsRoot.width * 0.04
                    color: focus ? "white" : "grey"
                }
                TextEdit {
                    id: minTimeTextEdit
                    text: "0"
                    inputMethodHints: Qt.ImhDigitsOnly
                    font.pixelSize: timetableSettingsRoot.width * 0.04
                    color: focus ? "white" : "grey"
                    onTextChanged: {
                        if(stationSelector.currentItem) {
                            var currentData = stationSelector.model.get(stationSelector.currentIndex)
                            currentData.minTime = parseInt(text)
                            stationSelector.model.set(stationSelector.currentIndex, currentData)
                            saveStations()
                        }
                    }
                    KeyNavigation.down: directionsTextEdit
                }
            }
            Row {
                spacing: timetableSettingsRoot.width * 0.01
                Text {
                    text: "Directions:"
                    font.pixelSize: timetableSettingsRoot.width * 0.04
                    color: focus ? "white" : "grey"
                }
                TextEdit {
                    id: directionsTextEdit
                    text: "0"
                    inputMethodHints: Qt.ImhDigitsOnly
                    font.pixelSize: timetableSettingsRoot.width * 0.04
                    color: focus ? "white" : "grey"
                    onTextChanged: {
                        if(stationSelector.currentItem) {
                            var currentData = stationSelector.model.get(stationSelector.currentIndex)
                            currentData.directions = text
                            stationSelector.model.set(stationSelector.currentIndex, currentData)
                            saveStations()
                        }
                    }
                    KeyNavigation.up: minTimeTextEdit
                    KeyNavigation.down: deleteButton
                }
            }
            Text {
                id: deleteButton
                text: "Delete"
                font.pixelSize: timetableSettingsRoot.width * 0.04
                color: focus ? "white" : "grey"
                KeyNavigation.up: directionsTextEdit

                Keys.onPressed: {
                    if(event.key === Qt.Key_Return) {
                        stationSelector.model.remove(stationSelector.currentIndex)
                        timetableSettingsRoot.focus = true
                        saveStations()
                    }
                }
            }
        }
    }

    Item {
        id: searchOverlay

        signal done

        width: parent.width * 0.8
        height: parent.height * 0.8
        anchors.centerIn: parent

        enabled: false
        opacity: 0

        onDone: {
            enabled = false
            opacity = 0
            timetableSettingsRoot.focus = true
        }

        onFocusChanged: {
            if(focus) {
                searchTextEdit.focus = true
            }
        }

        ListModel {
            id: searchModel
            signal loadCompleted()
        }

        Rectangle {
            id: background
            anchors.fill: parent
            radius: parent.width * 0.01
            color: "black"
        }

        Column {
            anchors.fill: parent
            anchors.margins: parent.width * 0.02
            spacing: timetableSettingsRoot.width * 0.02

            Text {
                id: searchText
                font.pixelSize: timetableSettingsRoot.width * 0.04
                color: "grey"
                text: "Search"
            }

            TextEdit {
                id: searchTextEdit
                height: timetableSettingsRoot.width * 0.05
                font.pixelSize: timetableSettingsRoot.width * 0.04
                width: parent.width
                color: focus ? "white" : "grey"

                text: ""
                onTextChanged: {
                    Travels.findStations(text, true, searchModel)
                }

                KeyNavigation.down: searchListView
            }

            ListView {
                id: searchListView
                height: parent.height - searchText.height - searchTextEdit.height - parent.anchors.margins * 5
                width: parent.width

                model: searchModel
                clip: true

                delegate: Text {
                    font.pixelSize: timetableSettingsRoot.width * 0.03
                    color: activeFocus ? "white" : "grey"

                    text: name
                    Keys.onPressed: {
                        if(event.key === Qt.Key_Return)  {
                            var station = {name: name, stationID: "" + stationID, directions: "all", minTime: 0};
                            addStation(station);
                            searchOverlay.done();
                        }
                    }
                }
                highlight: Rectangle {
                    color: searchListView.focus ? "white" : "lightgrey"
                    width: parent.width
                    radius: timetableSettingsRoot.width * 0.01
                    opacity: 0.1
                }

                KeyNavigation.up: searchTextEdit
            }
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_Escape) {
                searchOverlay.done()
                event.accepted = true
            }
        }
    }
}
