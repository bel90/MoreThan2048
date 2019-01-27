import QtQuick 2.0
//import "../../assets"
import "../common/"

Rectangle {
    id: button2048

    property alias text: butText.text

    signal clicked

    height: butText.height + 10
    width: butText.width + 10
    radius: 5
    color: "transparent" //"#416071" //"#121721"

    Image {
        id: but
        source: "../../assets/11b.png" //"../../assets/7b.png"
        anchors.fill: parent
    }

    ShadowText {
        id: butText
        anchors.centerIn: parent
        pixelSize: 15
        color1: "black"
        color2: "lightgrey"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button2048.clicked()
        onPressed: button2048.opacity = 0.5
        onReleased: button2048.opacity = 1
        onEntered: button2048.opacity = 0.8
        onExited: button2048.opacity = 1
    }
}
