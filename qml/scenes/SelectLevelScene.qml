import QtQuick 2.0
import VPlay 2.0
import "../common/"
import "../buttons/"
import "../common/bigInteger.js" as Big

SceneBase {
    id: selectLevelScene

    BubbleBackground { }

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

    Button2048 {
        text: "test"
        onClicked: {
            /*
            console.log(9872, 3453, Big.addTwoBigInt(Big.createBigInt(9872), Big.createBigInt(3453)))
            console.log(9999, 9, Big.addTwoBigInt("9999999999999999999999999999999999999999999999999", Big.createBigInt(9)))
            console.log(Big.addTwoBigInt("1896489489618989431584897896541236985247789426854556489789743123156465789798", "1984048904894098794563"))
            */
            var tmp = "1"
            for (var i = 1; i <= 64; i++) {
                tmp = Big.powBigInt(tmp)
                console.log(i, tmp)
                console.log(Big.bigIntToTile(tmp))
            }
        }
    }

    function setUpGame(gridSizeGame) {
        gameWindow.gameScene.setUpGame(gridSizeGame);
    }
}
