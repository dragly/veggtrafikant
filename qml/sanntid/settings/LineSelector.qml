import QtQuick 2.3
import QtQuick.Controls 1.3
import "../JSONListModel"

Item {
    id: lineSelectorRoot
    property var station
    signal done(var station)

    function reset() {
        allSwitch.checked = true
        searchModel.searchString = ""
    }

    width: 100
    height: 62
    LineModel {
        id: searchModel
        property string searchString: ""
        stationID: station && station.stationID ? station.stationID : ""
    }

    Flickable {
        anchors.fill: parent
        clip: true
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: searchListView.width * 0.05

            Text {
                font.pixelSize: lineSelectorRoot.width * 0.05
                color: theme.duseFront
                font.weight: Font.Light
                text: qsTr("Choose lines")
            }

            SettingsButton {
                text: qsTr("Save")
                onClicked: {
                    if(allSwitch.checked) {
                        lineSelectorRoot.station.directions = "all"
                    } else {
                        lineSelectorRoot.station.directions = ""
                        for(var i = 0; i < searchModel.model.count; i++) {
                            var directionData = searchModel.model.get(i)
                            if(directionData.switchChecked) {
                                lineSelectorRoot.station.directions += "" + directionData.LineRef + directionData.DestinationRef
                                if(i < searchModel.model.count - 1) {
                                    lineSelectorRoot.station.directions += ","
                                }
                            }
                        }
                    }
                    lineSelectorRoot.done(lineSelectorRoot.station)
                }
            }

            Item {
                height: searchListView.width * 0.1
                width: parent.width
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: theme.duseBack
                }
                Text {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: parent.width * 0.05
                    }
                    text: "All"
                    font.pixelSize: lineSelectorRoot.width * 0.05
                    color: theme.strongFront
                    font.weight: Font.Light
                }
                Switch {
                    id: allSwitch
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: parent.width * 0.05
                    }
                    checked: true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        allSwitch.checked = !allSwitch.checked
                    }
                }
            }

            Item {
                width: parent.width
                height: searchListView.height
                Rectangle {
                    anchors.fill: searchListView
                    radius: 8
                    color: theme.duseBack
                }

                ListView {
                    id: searchListView
                    width: parent.width
                    height: searchListView.width * 0.1 * model.count
                    model: searchModel.model
                    enabled: !allSwitch.checked
                    delegate: Item {
                        id: delegateItem
                        width: searchListView.width
                        height: searchListView.width * 0.1

                        Rectangle {
                            anchors {
                                bottom: parent.bottom
                                left: lineText.left
                                right: parent.right
                            }
                            height: 2
                            color: theme.middle
                            visible: index < searchListView.model.count - 1
                        }
                        Text {
                            id: lineText
                            anchors {
                                leftMargin: parent.width * 0.05
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }
                            text: model.PublishedLineName + " " + model.DestinationName
                            font.pixelSize: delegateItem.height * 0.5
                            color: theme.strongFront
                            font.weight: Font.Light
                        }
                        Switch {
                            id: lineSwitch
                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                margins: parent.width * 0.05
                            }
                            checked: model.switchChecked
                            onCheckedChanged: {
                                searchModel.model.setProperty(index, "switchChecked", checked)
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                lineSwitch.checked = !lineSwitch.checked
                            }
                        }
                    }
                }
                MouseArea {
                    anchors.fill: searchListView
                    propagateComposedEvents: true
                    onClicked: {
                        if(allSwitch.checked) {
                            allSwitch.checked = false
                        } else {
                            mouse.accepted = false
                        }
                    }
                }
            }

            BusyIndicator {
                visible: !searchModel.ready
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: parent.width
                height: lineSelectorRoot.width * 0.05
            }
        }
    }
}
