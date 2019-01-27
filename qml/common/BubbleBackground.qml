import QtQuick 2.0
import VPlay 2.0

Image {
    anchors.fill: parent.gameWindowAnchorItem
    source: "../../assets/background2048.png"
    fillMode: Image.PreserveAspectCrop
    ParticleVPlay {
        id: particle
        fileName: "../../assets/2048Flubber.json"
        autoStart: true
        x: gameScene.width / 2
        y: gameScene.height / 2
        sourcePositionVariance: Qt.point(gameScene.width / 2, gameScene.height / 2)
    }
}
