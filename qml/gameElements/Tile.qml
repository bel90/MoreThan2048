import QtQuick 2.2
import VPlay 2.0

EntityBase{
    id: tile
    entityType: "Tile"

    width: gameScene.gridWidth / gameScene.gridSizeGame
    height: width // square so height=width

    property int tileIndex // is responsible for a position of the tile
    property int tileValue // tileValue is what gets incremented every time 2 tiles get merged
    property color tileColor
    property color tileTextColor: "white"
    property string tileText

    // tileFontSize is deduced from the tile width, therefore it will always fit into the tile(up to 10^5)
    property int tileFontSize: width / 3

    // animationDuration is responsible for how long an animation will go
    // 500ms for desktop and 250ms for mobiles
    property int animationDuration: system.desktopPlatform ? 300 : 200

    // tileColor corresponds to the tileValue
                           //0          1          2          3          4          5          6          7          8          9         10         11
    //property var bgColors: ["#000000", "#88B605", "#587603", "#293601", "#48765F", "#1A9C70", "#14C3B6", "#1591B6", "#1668C3", "#1C15B6", "#821DB6", "#C31555"]
    //60% Sättigung der Farben
    property var bgColors: ["#6fdc6f", "#5bd75b", "#46d246", "#32cd32", "#2db92d", "#28a428", "#239023", "#1e7b1e", "#196719", "#145214", "#0f3e0f", "#0a290a"]
    //property var bgColors: ["#33ff33", "#1aff1a", "#00ff00", "#00e600", "#00cc00", "#00b300", "#009900", "#008000", "#006600", "#004d00", "#003300", "#001a00"]

    // tile rectangle
    Rectangle {
        id: innerRect
        anchors.centerIn: parent // center this object in the invisible "EntityBase"
        width: parent.width - 2 // -2 is the width offset, set it to 0 is no offset is needed
        height: width // square so height=width
        radius: 4 // radius of tile corners
        color: bgColors[tileValue]

        // tile text
        Text {
            id: innerRectText
            anchors.centerIn: parent // center this object in the "innerRect"
            color: tileTextColor
            font.pixelSize: tileFontSize
            text: Math.pow(2, tileValue) // tileValue gets squared according to the 2048 rules (1,2,3) ->(2,4,6)
        }
    }

    // startup position calculation
    Component.onCompleted: {
        x = (width) * (tileIndex % gameScene.gridSizeGame) // we get the current row and multiply with the width to get the current position
        y = (height) * Math.floor(tileIndex/gameScene.gridSizeGame) // we get the current column and multiply with the width to get the current position
        tileValue = Math.random() < 0.8 ? 1 : 2 // a new tile has 20% = 4 and 80% = 2
        showTileAnim.start() // new tile animation trigger
        //Teil wurde gerade erstellt -> Erhöhe den Score
        gameScene.score += Math.pow(2, tileValue)
    }

    // this methods gets called every time a tile moves
    // it has exactly the same kind of behavior as our previous method
    // however, the values get transfered to a targetPoint to simplify our movement animations
    function moveTile(newTileIndex) {
        tileIndex = newTileIndex
        moveTileAnim.targetPoint.x = ((width) * (tileIndex % gameScene.gridSizeGame))
        moveTileAnim.targetPoint.y = ((height) * Math.floor(tileIndex/gameScene.gridSizeGame))
        moveTileAnim.start()
    }

    function destroyTile() { // trigger tile death animation
        //Teil wurde mit einem anderen zusammengeführt -> erhöhe den Score
        gameScene.score += Math.pow(2, tileValue + 1)
        deathAnimation.start()
    }

    // in a parallel animation, animations which are inside will run at the same time
    ParallelAnimation {
        id: showTileAnim

        // number animation works with any real number
        NumberAnimation {
            target: innerRect // specify the target of the animation
            property: "opacity" // specify the property that will be animated
            from: 0.0
            to: 1.0
            duration: animationDuration
        }

        // ScaleAnimator used for scaling
        ScaleAnimator {
            target: innerRect
            from: 0
            to: 1
            duration: animationDuration
            easing.type: Easing.OutQuad // Easing used to put some live action in your animation
        }
    }

    // movement animation
    ParallelAnimation {
        id: moveTileAnim
        property point targetPoint: Qt.point(0,0)
        NumberAnimation {
            target: tile
            property: "x"
            duration: animationDuration/2
            to: moveTileAnim.targetPoint.x
        }
        NumberAnimation {
            target: tile
            property: "y"
            duration: animationDuration/2
            to: moveTileAnim.targetPoint.y
        }
    }

    // a ScriptAction is treated like an animation, so the SequentialAnimation will call this script after the previous animation has finished
    // in other words, when the tile is completely faded out, it will be removed
    SequentialAnimation {
        id: deathAnimation
        NumberAnimation {
            target: innerRect
            property: "opacity"
            from: 1
            to: 0
            duration: animationDuration/2
        }
        ScriptAction {
            script: removeEntity() // removesEntity from the game
        }
    }
}
