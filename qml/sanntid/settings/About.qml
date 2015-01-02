import QtQuick 2.3

Item {
    id: aboutRoot
    Column {
        anchors.fill: parent
        SettingsHeading {
            text: qsTr("About")
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            color: theme.duseFront
            font.pixelSize: aboutRoot.width * 0.04
            font.weight: Font.Light
            text: qsTr("Sanntid is an application developed by Svenn-Arne Dragly. " +
                       "It is open source and licensed under the GNU GPL v3 license.\n\n" +
                       "Weather forecast from yr.no, delivered by the Norwegian Meteorological Institute and the NRK.\n\n" +
                       "Transportation data from ruter.no, under the NLOD license.\n\n" +
                       "News from NRK.")
        }
    }
}
