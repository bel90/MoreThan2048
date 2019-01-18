import QtQuick 2.0
import VPlay 2.0

Rectangle {
    id: backButton

    color: "transparent"
    height: childrenRect.height
    width: childrenRect.width

    //clicked Handler
    signal clicked

    Image {
        //source: "../../svg/backButton.svg"
        source: "../../assets/backButton.png"
        height: 40
        width: 40
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: backButton.clicked()
        onPressed: backButton.opacity = 0.5
        onReleased: backButton.opacity = 1
    }
}
