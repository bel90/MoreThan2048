import QtQuick 2.0

Item {
    property alias text: butText.text
    property alias pixelSize: butText.font.pixelSize
    property alias color1: butText.color
    property alias color2: butText2.color

    width: butText.width + (butText.font.pixelSize / 15)
    height: butText.height + (butText.font.pixelSize / 15)
    //color: "transparent"

    Text {
        id: butText2
        x: butText.x + (butText.font.pixelSize / 15)
        y: butText.y + (butText.font.pixelSize / 15)
        font.pixelSize: butText.font.pixelSize
        color: "black"
        text: butText.text
    }

    Text {
        id: butText
        anchors.centerIn: parent
        //font.pixelSize: 15
        color: "white"
    }
}
