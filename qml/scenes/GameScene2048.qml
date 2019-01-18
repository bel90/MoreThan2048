import VPlay 2.0
import QtQuick 2.2
import "../common/"
import "../gameElements/"
import "../buttons/"

SceneBase {
    id: gameScene

    signal backButPressed

    EntityManager {
        id: entityManager
        entityContainer: gameContainer
    }

    //logical game size which is auto scaled
    width: gameWindow.logicalWidth
    height: gameWindow.logicalHeight

    property int gridWidth: 300
    property int gridSizeGame: 2
    property int gridSizeGameSquared: gridSizeGame * gridSizeGame
    property var emptyCells: []
    property var tileItems: new Array(gridSizeGameSquared)

    property int score: 0
    property int highscore: 0
    property var restoreStr

    function setUpGame(gridSizeG) {
        //aktuell noch Test, richtiges laden muss noch implementiert werden

        //Wenn kein Spielstand geladen wurde
        if (!loadGame(gridSizeG)) {
            resetGame(gridSizeG)

            //create two random tiles
            createNewTile()
            createNewTile()
            if (gridSizeGame > 4) {
                createNewTile()
                if (gridSizeGame > 6) createNewTile()
            }
        }

        //Lade den highscore
        var high = "highscore" + gridSizeGame
        var hs = localStorage.getValue(high)
        if (hs !== undefined) {
            highscore = hs
        } else {
            highscore = 0
        }
    }

    function resetGame(gridSizeG) {
        gameoverText.visible = false;
        entityManager.removeAllEntities()
        gameScene.gridSizeGame = gridSizeG
        score = 0
        restoreStr = undefined
        tileItems = new Array(gridSizeGameSquared)
        //fill the main array with empty spaces
        for (var i = 0; i < gridSizeGameSquared; i++) {
            tileItems[i] = null
        }
        //collect empty cells positions
        updateEmptyCells()
    }

    function saveGame() {
        var key = "savedGame" + gridSizeGame
        //Wenn GameOver ist lösche den letzten Spielstand im localStorage
        if (isGameOver()) {
            localStorage.clearValue(key)
            return
        }

        //Den aktuellen Score noch mit speichern
        var saveArray = score.toString()
        //var saveArray = tileItems[0] === null ? null : tileItems[0].tileValue
        for (var i = 0; i < tileItems.length; i++) {
            saveArray += ";"
            saveArray += tileItems[i] === null || tileItems[i] === undefined ? null : tileItems[i].tileValue
        }

        localStorage.setValue(key, saveArray)
    }

    //return true if game is loaded, false otherwise
    function loadGame(gridSizeG) {
        var key = "savedGame" + gridSizeG
        var tmp = localStorage.getValue(key)
        if (tmp !== undefined) {
            //restore the game
            restore(tmp, gridSizeG)

            return true
        }
        return false
    }

    //Zum wiederherstellen des letzten Spielstandes (rückgängig machen des letzten Zuges)
    //und zum laden eines gespeicherten Spielstandes
    function restore(restoreString, gridSizeG) {
        resetGame(gridSizeG)
        var restoreArray = restoreString.split(";")

        //Befüle das Feld mit den gespeicherten Feldern neu
        for (var i = 1; i < restoreArray.length; i++) {
            if (restoreArray[i] !== "null") {
                var tileId = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("../gameElements/Tile.qml"), {"tileIndex": i - 1})
                tileItems[i - 1] = entityManager.getEntityById(tileId)
                tileItems[i - 1].tileValue = parseInt(restoreArray[i])
            }
        }
        updateEmptyCells()
        score = parseInt(restoreArray[0])
    }

    /*Rectangle {
        id: background
        anchors.fill: gameScene.gameWindowAnchorItem
        color: "#bdd1db" //30% Farbsättigung, 80% Helligkeit
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
        id: bestScore
        text: "Best Score: " + highscore
        pixelSize: 15
        anchors.top: gameScene.top
        anchors.right: scoreText.right
    }

    ShadowText {
        id: scoreText
        text: gameScene.score
        pixelSize: 20
        anchors {
            bottom: gameContainer.top
            bottomMargin: 10
            right: gameContainer.right
        }
    }

    ShadowText {
        text: "Score:"
        pixelSize: 11
        anchors {
            bottom: scoreText.top
            right: scoreText.right
        }
    }

    Item {
        id: gameContainer
        width: gameScene.gridWidth
        height: width
        anchors.centerIn: parent
        GameBackground {}
    }

    Timer {
        id: moveRelease
        interval: 100
    }

    Keys.forwardTo: keyboardController
    Item {
        id: keyboardController

        Keys.onPressed: {
            if (!system.desktopPlatform) return
            if (event.key === Qt.Key_Left && moveRelease.running === false) {
                event.accepted = true
                gameScene.moveLeft()
                moveRelease.start()
            } else if (event.key === Qt.Key_Right && moveRelease.running === false) {
                event.accepted = true
                gameScene.moveRight()
                moveRelease.start()
            } else if (event.key === Qt.Key_Up && moveRelease.running === false) {
                event.accepted = true
                gameScene.moveUp()
                moveRelease.start()
            } else if (event.key === Qt.Key_Down && moveRelease.running === false) {
                event.accepted = true
                gameScene.moveDown()
                moveRelease.start()
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: gameScene.gameWindowAnchorItem

        property int startX
        property int startY

        property string direction
        property bool moving: false

        onPressed: {
            startX = mouse.x
            startY = mouse.y
            moving = false
        }

        onReleased: {
            moving = false
        }

        onPositionChanged: {
            var deltaX = mouse.x - startX
            var deltaY = mouse.y -startY

            if (moving === false) {
                if (Math.abs(deltaX) > 40 || Math.abs(deltaY) > 40) {
                    moving = true

                    if (deltaX > 30 && Math.abs(deltaY) < 30 && moveRelease.running === false) {
                        gameScene.moveRight()
                        moveRelease.start()
                    } else if (deltaX < -30 && Math.abs(deltaY) < 30 && moveRelease.running === false) {
                        gameScene.moveLeft()
                        moveRelease.start()
                    } else if (deltaY > 30 && Math.abs(deltaX) < 30 && moveRelease.running === false) {
                        gameScene.moveDown()
                        moveRelease.start()
                    } else if (deltaY < -30 && Math.abs(deltaX) < 30 && moveRelease.running === false) {
                        gameScene.moveUp()
                        moveRelease.start()
                    }
                }
            }
        }
    }

    Text {
        id: gameoverText
        visible: false //Muss auf true gesetzt werden, wenns soweit ist
        text: "GAME OVER "
        color: "red"
        anchors.centerIn: parent
        font.pixelSize: 40
    }

    BackButton {
        x: 10
        y: 10
        onClicked: {
            saveGame()
            backButPressed()
            saveHighscore()
        }
    }

    onBackButtonPressed: {
        saveGame()
        backButPressed()
        saveHighscore()
    }

    Button2048 {
        id: resetButton
        anchors.left: gameContainer.left
        anchors.bottom: gameScene.bottom
        anchors.bottomMargin: 10
        onClicked: {
            //Lösche den gespeicherten Spielstand und
            //setze das Spielfeld neu auf
            localStorage.clearValue("savedGame" + gridSizeGame)
            //Speicher bei Bedarf den aktuellen Highscore
            saveHighscore()
            setUpGame(gridSizeGame)
        }
        text: "Restart"
    }

    Button2048 {
        id: undoButton
        anchors.right: gameContainer.right
        anchors.bottom: resetButton.bottom
        onClicked: {
            if (restoreStr !== undefined) {
                restore(restoreStr, gridSizeGame)
            }
        }
        text: "Undo"
    }

    Component.onCompleted: {
        setUpGame(gridSizeGame)
    }

    //extract and save emptyCells from tileItems
    function updateEmptyCells() {
        emptyCells = []
        for (var i = 0; i < gridSizeGameSquared; i++) {
            if (tileItems[i] === null) {
                emptyCells.push(i)
            }
        }
    }

    //creates new tile at random index (0-15)
    //positioning and value setting happens inside the tile class
    function createNewTile() {
        if (emptyCells.length < 1) return
        //get random emptyCells:
        var randomCellId = emptyCells[Math.floor(Math.random() * emptyCells.length)]
        //create new tile with a referenceID:
        var tileId = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("../gameElements/Tile.qml"), {"tileIndex": randomCellId})
        //paste new Tile to the array
        tileItems[randomCellId] = entityManager.getEntityById(tileId)
        //remove the emptyCell from emptyCell array
        emptyCells.splice(emptyCells.indexOf(randomCellId), 1)

        isGameOver()
    }

    function isGameOver() {
        //Kontrolliere ob es noch ein freies Feld gibt
        if (emptyCells.length < 1) {
            //Schaue ob irgendwelche Teile noch gemerged werden können
            //wenn nicht ist das Spiel vorbei
            for (var i = 0; i < gridSizeGame; i++) {
                for (var j = 0; j < gridSizeGame; j++) {
                    if ((i === gridSizeGame - 1) && (j === gridSizeGame - 1)) {
                        //letztes Feld, nichts zu tun
                    } else if ((j < gridSizeGame - 1) && (i === gridSizeGame - 1) && //Letzte Zeile kontrollieren
                              (tileItems[i * gridSizeGame + j].tileValue === tileItems[i * gridSizeGame + j + 1].tileValue)) {
                        return
                    } else if ((i < gridSizeGame - 1) && (j === gridSizeGame - 1) && //Letzte Spalte kontrollieren
                              (tileItems[i * gridSizeGame + j].tileValue === tileItems[(i + 1) * gridSizeGame + j].tileValue)) {
                        return
                    }
                    //Jetzt das aktuell betrachtete Teil überprüfen, ob es mit dem rechten
                    //oder unteren Nachbarn gemerged werden kann
                    else if ((j < gridSizeGame - 1) && (i < gridSizeGame - 1) && ((tileItems[i * gridSizeGame + j].tileValue === tileItems[(i + 1) * gridSizeGame + j].tileValue) ||
                        (tileItems[i * gridSizeGame + j].tileValue === tileItems[i * gridSizeGame + j + 1].tileValue))) {
                        return
                    }
                }
            }
            //Wenn hier noch nichts returned wurde, kann nichts mehr gemerged werden!
            gameOver()
            return true
        }
        return false
    }

    function gameOver() {
        saveHighscore()
        //Zeige an, dass das Spiel vorbei ist
        //Reseten des Spielfeldes erst wenn der Spieler bestätigt hat
        gameoverText.visible = true
    }

    function saveHighscore() {
        //Speicher den Highscore, falls der alte niedriger war
        var high = "highscore" + gridSizeGame
        var hs = localStorage.getValue(high)
        if ((hs === undefined) || (hs < score)) {
            localStorage.setValue(high, score)
        }
    }

    function merge(sourceRow) {
        var i, j
        var nonEmptyTiles = [] //sourceRow without empty tiles
        var indices = []

        //remove zero/empty elements
        for (i = 0; i < sourceRow.length; i++) {
            indices[i] = nonEmptyTiles.length
            if (sourceRow[i] > 0) {
                nonEmptyTiles.push(sourceRow[i])
            }
        }

        var mergedRow = [] //sourceRow after it was merged

        for (i = 0; i < nonEmptyTiles.length; i++) {
            //after all elements were pushed, push the last element, because there is no element after to be merged with
            if (i === nonEmptyTiles.length - 1) {
                mergedRow.push(nonEmptyTiles[i])
            } else {
                //comparing if values are mergeable
                if (nonEmptyTiles[i] === nonEmptyTiles[i + 1]) {
                    for (j = 0; j < sourceRow.length; j++) {
                        if (indices[j] > mergedRow.length) {
                            indices[j] -= 1
                        }
                    }

                    //elements got merged so a new element appears and gets incremented
                    //skip one element because it got merged
                    mergedRow.push(nonEmptyTiles[i] + 1)
                    i++
                } else {
                    //no merge, so follow normal order
                    mergedRow.push(nonEmptyTiles[i])
                }
            }
        }

        //fill empty spots with zeroes
        for (i = mergedRow.length; i < sourceRow.length; i++) {
            mergedRow[i] = 0
        }

        //create an object with the merged row array inside and return it
        return {mergedRow : mergedRow, indices: indices}
    }

    function getRowAt(index) {
        var row = []
        for (var j = 0; j < gridSizeGame; j++) {
            //if there are no tileItems at this spot, push(0) to the row, else push the tileIndex value
            if (tileItems[j + index * gridSizeGame] === null) {
                row.push(0)
            } else {
                row.push(tileItems[j + index * gridSizeGame].tileValue)
            }
        }
        return row
    }

    function saveCurrentState() {
        var saveArray = score.toString()
        for (var i = 0; i < tileItems.length; i++) {
            saveArray += ";"
            saveArray += tileItems[i] === null || tileItems[i] === undefined ? null : tileItems[i].tileValue
        }
        return saveArray
    }

    function moveLeft() {
        var isMoved = false //move happens not for a single cell but for a whole row
        var sourceRow, mergedRow, merger, indices
        var i, j
        var curState = saveCurrentState();

        for (i = 0; i < gridSizeGame; i++) {
            sourceRow = getRowAt(i)
            merger = merge(sourceRow)
            mergedRow = merger.mergedRow
            indices = merger.indices

            //checks if the given row is not the same as before
            if (!arraysIdentical(sourceRow, mergedRow)) {
                isMoved = true
                //merges and move tileItems elements
                for (j = 0; j < sourceRow.length; j++) {
                    //checks if an element is not empty
                    if (sourceRow[j] > 0 && indices [j] !== j) {
                        //checks if a merge has happened and at what position
                        if (mergedRow[indices[j]] > sourceRow[j] && tileItems[gridSizeGame * i + indices[j]] !== null) {
                            //Move, merge and increment value of the merged element
                            //increment the value of the tile that got merged
                            tileItems[gridSizeGame * i + indices[j]].tileValue++
                            //move second tile in the merge direction
                            tileItems[gridSizeGame * i + j].moveTile(gridSizeGame * i + indices[j])
                            //and destroy it
                            tileItems[gridSizeGame * i + j].destroyTile()
                        } else {
                            //Move only
                            tileItems[gridSizeGame * i + j].moveTile(gridSizeGame * i + indices[j])
                            tileItems[gridSizeGame * i + indices[j]] = tileItems[gridSizeGame * i + j]
                        }
                        tileItems[gridSizeGame * i + j] = null
                    }
                }
            }
        }

        if (isMoved) {
            //update empty cells
            updateEmptyCells()
            //create new random position tile
            createNewTile()
            if (gridSizeGame > 4) {
                createNewTile()
                if (gridSizeGame > 6) createNewTile()
            }
            restoreStr = curState
        }
    }

    function moveRight() {
        var isMoved = false
        var sourceRow, mergedRow, merger, indices
        var i, j, k //k used for reversing
        var curState = saveCurrentState();

        for (i = 0; i < gridSizeGame; i++) {
            sourceRow = getRowAt(i).reverse()
            merger = merge(sourceRow)
            mergedRow = merger.mergedRow
            indices = merger.indices

            if (!arraysIdentical(sourceRow, mergedRow)) {
                isMoved = true
                //reverse all other arrays as well
                sourceRow.reverse()
                mergedRow.reverse()
                indices.reverse()
                //recalculate the indices from the end to the start
                for (j = 0; j < indices.length; j++) {
                    indices[j] = gridSizeGame - 1 - indices[j]
                }
                for (j = 0; j < sourceRow.length; j++) {
                    k = sourceRow.length - 1 - j

                    if (sourceRow[k] > 0 && indices[k] !== k) {
                        if (mergedRow[indices[k]] > sourceRow[k] && tileItems[gridSizeGame * i + indices[k]] !== null) {
                            // Move and merge
                            tileItems[gridSizeGame * i + indices[k]].tileValue++
                            tileItems[gridSizeGame * i + k].moveTile(gridSizeGame * i + indices[k])
                            tileItems[gridSizeGame * i + k].destroyTile()
                        } else {
                            // Move only
                            tileItems[gridSizeGame * i + k].moveTile(gridSizeGame * i + indices[k])
                            tileItems[gridSizeGame * i + indices[k]] = tileItems[gridSizeGame * i + k]
                        }
                        tileItems[gridSizeGame * i + k] = null
                    }
                }
            }
        }

        if (isMoved) {
            updateEmptyCells()
            createNewTile()
            if (gridSizeGame > 4) {
                createNewTile()
                if (gridSizeGame > 6) createNewTile()
            }
            restoreStr = curState
        }
    }

    function moveUp() {
        var isMoved = false
        var sourceRow, mergedRow, merger, indices
        var i, j
        var curState = saveCurrentState();

        for (i = 0; i < gridSizeGame; i++) {
            sourceRow = getColumnAt(i)
            merger = merge(sourceRow)
            mergedRow = merger.mergedRow
            indices = merger.indices

            if (! arraysIdentical(sourceRow,mergedRow)) {
                isMoved = true
                for (j = 0; j < sourceRow.length; j++) {
                    if (sourceRow[j] > 0 && indices[j] !== j) {
                        // keep in mind now we are working with COLUMNS NOT ROWS!
                        // i and j are swapped when arranging tileItems
                        if (mergedRow[indices[j]] > sourceRow[j] && tileItems[gridSizeGame * indices[j] + i] !== null) {
                            // Move and merge
                            tileItems[gridSizeGame * indices[j] + i].tileValue++
                            tileItems[gridSizeGame * j + i].moveTile(gridSizeGame * indices[j] + i)
                            tileItems[gridSizeGame * j + i].destroyTile()
                        } else {
                            // just move
                            tileItems[gridSizeGame * j + i].moveTile(gridSizeGame * indices[j] + i)
                            tileItems[gridSizeGame * indices[j] + i] = tileItems[gridSizeGame * j + i]
                        }
                        tileItems[gridSizeGame * j + i] = null
                    }
                }
            }
        }

        if (isMoved) {
            // update empty cells
            updateEmptyCells()
            // create new random position tile
            createNewTile()
            if (gridSizeGame > 4) {
                createNewTile()
                if (gridSizeGame > 6) createNewTile()
            }
            restoreStr = curState
        }
    }

    function moveDown() {
        var isMoved = false
        var sourceRow, mergedRow, merger, indices
        var j, k
        var curState = saveCurrentState();

        for (var i = 0; i < gridSizeGame; i++) {
            sourceRow = getColumnAt(i).reverse()
            merger = merge(sourceRow)
            mergedRow = merger.mergedRow
            indices = merger.indices

            if (! arraysIdentical(sourceRow,mergedRow)) {
                isMoved = true
                sourceRow.reverse()
                mergedRow.reverse()
                indices.reverse()

                for (j = 0; j < gridSizeGame; j++)
                    indices[j] = gridSizeGame - 1 - indices[j]

                for (j = 0; j < sourceRow.length; j++) {
                    k = sourceRow.length -1 - j

                    if (sourceRow[k] > 0 && indices[k] !== k) {
                        // keep in mind now we are working with COLUMNS NOT ROWS!
                        // i and k will be swapped when arranging tileItems
                        if (mergedRow[indices[k]] > sourceRow[k] && tileItems[gridSizeGame * indices[k] + i] !== null) {
                            // Move and merge
                            tileItems[gridSizeGame * indices[k] + i].tileValue++
                            tileItems[gridSizeGame * k + i].moveTile(gridSizeGame * indices[k] + i)
                            tileItems[gridSizeGame * k + i].destroyTile()

                        } else {
                            // Move only
                            tileItems[gridSizeGame * k + i].moveTile(gridSizeGame * indices[k] + i)
                            tileItems[gridSizeGame * indices[k] + i] = tileItems[gridSizeGame * k + i]
                        }
                        tileItems[gridSizeGame * k + i] = null
                    }
                }
            }
        }

        if (isMoved) {
            updateEmptyCells()
            createNewTile()
            if (gridSizeGame > 4) {
                createNewTile()
                if (gridSizeGame > 6) createNewTile()
            }
            restoreStr = curState
        }
    }

    function getColumnAt(index) {
        var column = []
        for (var j = 0; j < gridSizeGame; j++) {
            //if there are no tileItems at this spot, push(0) to the column, else push the tileIndex value
            if (tileItems[index + j * gridSizeGame] === null) {
                column.push(0)
            } else {
                column.push(tileItems[index + j * gridSizeGame].tileValue)
            }
        }
        return column
    }

    function arraysIdentical(a, b) {
        var i = a.length
        if (i !== b.length) return false
        while (i--) {
            if (a[i] !== b[i]) return false
        }
        return true
    }
}
