import QtQuick 2.0
//import "../../assets"

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
        source: "../../assets/7b.png"
        anchors.fill: parent
    }

    Text {
        x: butText.x + 1
        y: butText.y + 1
        font.pixelSize: butText.font.pixelSize
        color: "black"
        text: butText.text
    }

    Text {
        id: butText
        anchors.centerIn: parent
        font.pixelSize: 15
        color: "white"
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
