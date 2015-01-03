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
            textFormat: Text.RichText
            text: qsTr("Sanntid is an application developed by Svenn-Arne Dragly. " +
                       "It is open source and licensed under the GNU GPL v3 license.<br><br>" +
                       "Would you like a tailored version or for us to install a monitor at your offices? " +
                       "Contanct us at <a style='color: \"#FFF\"' href='mailto:sanntid@dragly.org'>sanntid@dragly.org</a> for more information.<br><br>" +
                       "Weather forecast from yr.no, delivered by the Norwegian Meteorological Institute and the NRK.<br><br>" +
                       "Transportation data from ruter.no, under the NLOD license.<br><br>" +
                       "News from NRK.")
            onLinkActivated: {
                Qt.openUrlExternally(link)
            }
        }
    }
}
