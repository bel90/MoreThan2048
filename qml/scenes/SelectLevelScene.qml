import QtQuick 2.0
import VPlay 2.0
import "../common/"
import "../buttons/"

SceneBase {
    id: selectLevelScene

    /*Rectangle {
        anchors.fill: parent.gameWindowAnchorItem
        color: "#dee3ed"
    }*/

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

    ShadowText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 25
        pixelSize: 50//30
        text: "2048"
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Button2048 {
            text: "2*2"
            width: 40
            onClicked: {
                setUpGame(2)
                gameWindow.state = "gameScene"
            }
        }
        Button2048 {
            text: "3*3"
            width: 40
            onClicked: {
                setUpGame(3)
                gameWindow.state = "gameScene"
            }
        }
        Button2048 {
            text: "4*4"
            width: 40
            onClicked: {
                setUpGame(4)
                gameWindow.state = "gameScene"
            }
        }
        Button2048 {
            text: "5*5"
            width: 40
            onClicked: {
                setUpGame(5)
                gameWindow.state = "gameScene"
            }
        }
        Button2048 {
            text: "6*6"
            width: 40
            onClicked: {
                setUpGame(6)
                gameWindow.state = "gameScene"
            }
        }
        Button2048 {
            text: "7*7"
            width: 40
            onClicked: {
                setUpGame(7)
                gameWindow.state = "gameScene"
            }
        }
        Button2048 {
            text: "8*8"
            width: 40
            onClicked: {
                setUpGame(8)
                gameWindow.state = "gameScene"
            }
        }
        Button2048 {
            text: "9*9"
            width: 40
            onClicked: {
                setUpGame(9)
                gameWindow.state = "gameScene"
            }
        }
    }

    function setUpGame(gridSizeGame) {
        gameWindow.gameScene.setUpGame(gridSizeGame);
    }
}
