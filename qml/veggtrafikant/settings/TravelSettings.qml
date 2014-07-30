import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.dragly.veggtrafikant 1.0
import "../travels.js" as Travels
import ".."

Item {
    id: timetableSettingsRoot

    focus: true
    clip: true

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
            stationSelectorListView.focus = true
        }
    }

    ListModel {
        id: stationsModel
    }

    SettingsStorage {
        id: settingsStorage
    }

    StationSettingsOverlay {
        id: stationSettingsOverlay
        visible: false

        width: parent.width
        height: parent.height

        onDeleteStation: {
            stationSelectorListView.model.remove(stationSelectorListView.currentIndex)
            timetableSettingsRoot.focus = true
            saveStations()
            stackView.pop()
        }

        onDone: {
            if(stationSelectorListView.currentItem) {
                var currentData = stationSelectorListView.model.get(stationSelectorListView.currentIndex)
                currentData.minTime = parseInt(minTime)
//                currentData.directions = directions
                stationSelectorListView.model.set(stationSelectorListView.currentIndex, currentData)
                saveStations()
            }
            stackView.pop()
        }

//        onCancel: {
//            stackView.pop()
//        }
    }

    SearchOverlay  {
        id: searchOverlay
        visible: false
        width: parent.width
        height: parent.height
        onDone: {
            lineSelector.reset()
            var station = {name: name, stationID: "" + stationID, directions: "all", minTime: 0};
            lineSelector.station = station
            stackView.push(lineSelector)
        }
    }

    LineSelector {
        id: lineSelector
        visible: false
        width: parent.width
        height: parent.height
        onDone: {
            stackView.pop(currentStops)
            timetableSettingsRoot.addStation(station);
            timetableSettingsRoot.focus = true
        }
    }

    Item {
        id: linesSelector
        visible: false
        width: parent.width
        height: parent.height
    }

    Row {
        id: headingRow
        height: timetableSettingsRoot.width * 0.08
        width: parent.width
        Image {
            source: "../images/navigation_previous_item.png"
            width: parent.height
            height: width
            visible: stackView.depth > 1

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stackView.pop()
                }
            }
        }

        SettingsHeading {
            id: travelSettingsHeading
            text: qsTr("Stations")
        }
    }

    Item {
        id: currentStops
        width: parent.width
        height: parent.height
        Column {
            id: stationColumn
            anchors.fill: parent
            spacing: settingsRoot.height * 0.02

            SettingsButton {
                id: addButton
                text: "Add"

                function startSearch() {
                    searchOverlay.visible = true
                    stackView.push(searchOverlay)
                }

                Keys.onPressed: {
                    if(event.key === Qt.Key_Return) {
                        startSearch()
                    }
                }
                onClicked: {
                    addButton.startSearch()
                }
            }

            Item {
                width: parent.width
                height: stationSelectorListView.height

                SettingsListViewBackground {
                    anchors.fill: stationSelectorListView
                }

                ListView {
                    id: stationSelectorListView

                    width: parent.width
                    //            height: parent.height - addButton.height * 2
                    height: timetableSettingsRoot.width * 0.1 * count
                    model: stationsModel
                    clip: true
                    delegate: Item {
                        id: delegateItem
                        property variant myData: model
                        property bool isCurrent: stationSelectorListView.activeFocus && delegateItem.ListView.isCurrentItem
                        width: stationSelectorListView.width
                        height: timetableSettingsRoot.width * 0.1

                        Rectangle {
                            anchors {
                                bottom: parent.bottom
                                left: stationNameText.left
                                right: parent.right
                            }
                            height: 2
                            color: theme.duseFront
                            visible: index < stationSelectorListView.model.count - 1
                        }

                        Text {
                            id: stationNameText
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: parent.width * 0.03
                            }
                            text: model.name
                            font.pixelSize: delegateItem.height * 0.4
                            font.weight: Font.Light
                            color: theme.strongFront

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                stationSelectorListView.currentIndex = index
                                stackView.push(stationSettingsOverlay)
                            }
                        }
                    }

                    KeyNavigation.down: addButton
                    KeyNavigation.right: stationSettingsOverlay

                    onCurrentItemChanged: {
                        if(currentIndex >= 0) {
                            stationSettingsOverlay.minTime = currentItem.myData.minTime
//                            stationSettingsOverlay.directions = currentItem.myData.directions
                        }
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors {
            top: headingRow.bottom
            topMargin: parent.width * 0.05
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        focus: true
        Keys.onReleased: {
            if (event.key === Qt.Key_Back && stackView.depth > 1) {
                stackView.pop();
                event.accepted = true;
            }
        }
        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
            }

            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    easing.type: Easing.InOutCubic
                    duration: 500
                    property: "scale"
                    from: 0.9
                    to: 1
                }
                PropertyAnimation {
                    target: enterItem
                    easing.type: Easing.InOutCubic
                    duration: 500
                    property: "opacity"
                    from: 0.0
                    to: 1
                }
                PropertyAnimation {
                    target: exitItem
                    easing.type: Easing.InOutCubic
                    duration: 250
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }

            popTransition: StackViewTransition {
                PropertyAnimation {
                    target: exitItem
                    easing.type: Easing.InOutCubic
                    duration: 500
                    property: "scale"
                    from: 1
                    to: 0.9
                }
                PropertyAnimation {
                    target: exitItem
                    easing.type: Easing.InOutCubic
                    duration: 500
                    property: "opacity"
                    from: 1
                    to: 0
                }
                PropertyAnimation {
                    target: enterItem
                    easing.type: Easing.InOutCubic
                    duration: 250
                    property: "opacity"
                    from: 0
                    to: 1
                }
            }
        }
        initialItem: currentStops
    }
}
