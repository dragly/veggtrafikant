import QtQuick 2.0

Item {
    Column {
        anchors.fill: parent
        SettingsHeading {
            text: qsTr("About")
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("Veggtrafikant is an application developed by Svenn-Arne Dragly.

ccache is a clever tool that wraps you compiler (g++ or mpicxx) and understands whether the file you are compiling has been compiled before with exactly the same contents and settings. If it has, it just returns a cached result.

Unlike regular make, ccache is extremely good at detecting the true state of what you are compiling. I have never had any trouble with ccache.

This really speeds up the compilation when you are using make clean, especially if you are switching git branches. In other words, it is a much simpler solution to achieve fast compilation with git branches than to create separate build folders for each branch.
- See more at: http://dragly.org/#sthash.8EzJXQc8.dpuf")
        }
    }
}
