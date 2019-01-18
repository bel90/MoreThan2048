import QtQuick 2.0

Item {
    property alias text: butText.text
    property alias pixelSize: butText.font.pixelSize

    width: butText.width + (butText.font.pixelSize / 15)
    height: butText.height + (butText.font.pixelSize / 15)
    //color: "transparent"

    Text {
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
