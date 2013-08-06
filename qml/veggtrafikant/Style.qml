import QtQuick 2.0

QtObject {
    property color text: "#000000"
    property color travelText: "#FFFFFF"
    property Gradient background: Gradient {
                    GradientStop{ position: 0.0; color: "#71CBF6" }
                    GradientStop{ position: 0.2; color: "#71CBF6" }
                    GradientStop{ position: 0.8; color: "#0578AF" }
                }

    property color highlight: "#E6F7FF"
    property color textHighlight: "#E6F7FF"
    property color headings: "#000000"
    property color textEditBackground: "#000000"
    property color textEdit: "#FFFFFF"
    property color strongBack: "#000000"
    property color duseBack: "#BBBBBB"
    property color strongFront: "#FFFFFF"
    property color duseFront: "#777777"
    property color middle: "#0578AF"
}
