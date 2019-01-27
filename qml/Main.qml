import VPlay 2.0
import QtQuick 2.2
import "scenes/"

GameWindow {
    id: gameWindow

    // You get free licenseKeys from https://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://v-play.net/licenseKey>"
    //licenseKey: "39F9ECF8B7CF3336564280460C4C8F956BEBD0C2D1CEA646EDE7C637D3754D150318A2C3E762F9415327AF290FF685759D697140E8999983C5B845D155FD1C5E16B61B5143747502BF4336BA6179078114D63DD99B1BAD07A6C2C79EEF9A7614B02E74A47BADB7BF8F7C8230398BA1DBDE7AA8BC3BB654308F2FFC6213DDF050BDD114D8902976522F173ECAFE20E48103593DC457044B70FEA05546FEF7F65433C79D1680490CE62FDABD1C18444EC782E82DFDDF709222170D3FC16BCE9C16C581D4CF8A119F8E7900497EB2A1FAB5B39BE86188D251A33815BACF0C798608B8E7E272AEBE9C32852B9C471372AD4450FC2116FFEA654E532ABD1DC3F53811A2D0B99C0CE711936B973A3FE4F1A1DB14FE747303A25CF3D00DA6253953E89A8034ACB51021E23BBB26C9D6C3466C2D"

    screenWidth: 640
    screenHeight: 960

    //activeScene: gameScene

    property int highscore4: 0 //4 für das 4*4 Feld
    property int logicalWidth: 320
    property int logicalHeight: 480
    property alias gameScene: gameScene

    Storage {
        id: localStorage
    }

    EntityManager {
        id: entityManager
        entityContainer: gameScene.gameContainer
    }

    GameScene2048 {
        id: gameScene
        onBackButPressed: {
            gameWindow.state = "selectLevelScene"
        }
    }

    LevelBase {
        id: levelBase
    }

/*
    CreditsScene {
        id:creditsScene
    }
*/
    SelectLevelScene {
        id: selectLevelScene
    }

    state: "selectLevelScene"

    states:[
        State {
            name: "selectLevelScene"
            PropertyChanges {target: selectLevelScene; opacity: 1}
            PropertyChanges {target: gameWindow; activeScene: selectLevelScene}
        },/*
        State {
            name: "creditsScene"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: gameWindow; activeScene: creditsScene}
        },*/
        State {
            name: "gameScene"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: gameWindow; activeScene: gameScene}
        },
        State {
            name: "levelBase"
            PropertyChanges {target: levelBase; opacity: 1}
            PropertyChanges {target: gameWindow; activeScene: levelBase}
        }
    ]

}








