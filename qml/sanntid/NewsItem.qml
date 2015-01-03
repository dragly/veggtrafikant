import QtQuick 2.3
import QtQuick.XmlListModel 2.0

Item {
    id: newsRoot
    property int newsId: 0
    property string feedUrl
    function reload() {
        newsModel.reload()
    }

    Timer {
        id: switchNews
        triggeredOnStart: true
        repeat: true
        interval: 20 * 1000
        onTriggered: {
            if(newsText.opacity === 1.0) {
                newsAnimation.start()
                interval = 1000
            } else {
                if(newsModel.count > 0) {
                    newsId++
                    if(newsId >= newsModel.count) {
                        newsId = 0
                    }
                    newsText.text = newsModel.get(newsId).title + ": " + newsModel.get(newsId).description
                }
                newsAnimationBack.start()
                interval = 10 * 1000
            }
        }
    }
    Text {
        id: newsText
        anchors {
            fill: parent
        }

        text: qsTr("Updating news...")
        color: theme.travelText
        font.pixelSize: root.height * 0.038
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignTop
        clip: true
    }

    XmlListModel {
        id: newsModel
        source: newsRoot.feedUrl
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        onStatusChanged: {
            if(status == XmlListModel.Error) {
                console.log("News error: " + weatherModel.errorString())
            } else if(status == XmlListModel.Ready) {
                switchNews.start()
            }
        }
    }

    ParallelAnimation {
        id: newsAnimation
//        PropertyAnimation {
//            target: newsText
//            property: "scale"
//            from: 0.8
//            to: 1.0
//            easing.type: Easing.InOutCubic
//            duration: 750
//        }
        PropertyAnimation {
            target: newsText
            property: "opacity"
            from: 1.0
            to: 0.0
            easing.type: Easing.InOutCubic
            duration: 750
        }
    }
    ParallelAnimation {
        id: newsAnimationBack
        PropertyAnimation {
            target: newsText
            property: "scale"
            from: 0.92
            to: 1.0
            easing.type: Easing.InOutCubic
            duration: 750
        }
        PropertyAnimation {
            target: newsText
            property: "opacity"
            from: 0.0
            to: 1.0
            easing.type: Easing.InOutCubic
            duration: 750
        }
    }
}
