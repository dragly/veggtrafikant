import QtQuick 2.0

ListView {
    id: stationSelectorListView

    property alias delegateContent: delegateContentContainer

    Rectangle {
        anchors.fill: stationSelectorListView
        radius: 8
        color: theme.strongFront
        opacity: 0.1
    }

    width: parent.width
    height: parent.width * 0.1 * count
    delegate: Item {
        id: delegateItem
        width: stationSelectorListView.width
        height: timetableSettingsRoot.width * 0.1

        Rectangle {
            anchors {
                bottom: parent.bottom
                left: stationNameText.left
                right: parent.right
            }
            height: 2
            color: theme.strongFront
            opacity: 0.1
            visible: index < stationSelectorListView.model.count - 1
        }

        Item {
            id: delegateContentContainer
            default property alias contents: children
            anchors.fill: parent
        }
    }

    KeyNavigation.down: addButton
    KeyNavigation.right: stationSettingsOverlay
}
