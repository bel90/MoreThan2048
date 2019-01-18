import QtQuick 2.2
import VPlay 2.0

Rectangle {
    id: gameBackgound
    width: gameScene.gridWidth
    height: width
    color: "#77121721" //30% Farbsättigung, 10% Helligkeit
    radius: 5

    Grid {
        id: tileGrid
        anchors.centerIn: parent
        rows: gameScene.gridSizeGame

        //Repeater fills background with empty/orange tiles
        Repeater {
            id: cells
            model: gameScene.gridSizeGameSquared

            Item { //an invisible item holds tile width and height, so its easy to adjust the margins and offsets
                width: gameScene.gridWidth / gameScene.gridSizeGame
                height: width
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 2
                    height: width
                    color: "#77dee3ed" //30% Farbsättigung, 90% Helligkeit
                    radius: 4
                }
            }
        }
    }
}
