import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.XmlListModel 2.0
import "../JSONListModel"
import "../travels.js" as Travels

Item {
    id: searchOverlayRoot

    signal done(string name, string stationID)
    signal canceled()

    width: parent.width * 0.8
    height: parent.height * 0.8

    onFocusChanged: {
        if(focus) {
            searchTextEdit.focus = true
        }
    }

    //    ListModel {
    //        id: searchModel
    //        signal loadCompleted()
    //    }

    JSONListModel {
        id: searchModel
        property string searchString: ""
        source: searchString.length > 0 ? "http://reisapi.ruter.no/Place/GetPlaces/" +  searchString + "?json=true" : ""
        query: "$[?(@.RealTimeStop===true)]"
    }

    Column {
        anchors.fill: parent
        anchors.margins: parent.width * 0.02
        spacing: parent.width * 0.02

        Text {
            id: searchText
            font.pixelSize: searchOverlayRoot.width * 0.04
            color: "grey"
            text: "Search"
        }

        TextField {
            id: searchTextEdit
            height: searchOverlayRoot.width * 0.05
            font.pixelSize: searchOverlayRoot.width * 0.04
            width: parent.width

            text: ""
            onTextChanged: {
                searchModel.searchString = text
                //                Travels.findStations(text, true, searchModel)
            }
            onCursorPositionChanged: {
                searchModel.searchString = text
                //                Travels.findStations(text, true, searchModel)
            }

            KeyNavigation.down: searchListView
        }

        ListView {
            id: searchListView

            SettingsListViewBackground {
                anchors.fill: parent
            }

            height: searchOverlayRoot.width * 0.1 * count
            width: parent.width

            model: searchModel.model

            clip: true

            delegate: Item {
                id: delegateItem2
                width: searchListView.width
                height: searchListView.width * 0.1

                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        left: stopText.left
                        right: parent.right
                    }
                    height: 2
                    color: theme.strongFront
                    opacity: 0.1
                    visible: index < searchListView.model.count - 1
                }

                Text {
                    id: stopText
                    anchors {
                        leftMargin: parent.width * 0.05
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: model.Name
                    font.pixelSize: delegateItem2.height * 0.5
                    color: theme.strongFront
                    font.weight: Font.Light
                }

                Keys.onPressed: {
                    if(event.key === Qt.Key_Return)  {
                        searchOverlayRoot.done(model.Name, model.ID);
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        searchOverlayRoot.done(model.Name, model.ID);
                    }
                }
            }
            //            highlight:

            KeyNavigation.up: searchTextEdit
        }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Escape) {
            searchOverlayRoot.canceled()
            event.accepted = true
        }
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_Back) {
            searchOverlayRoot.canceled()
            event.accepted = true
        }
    }
}
