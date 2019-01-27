import QtQuick 2.0
import VPlay 2.0
import "../buttons/"
import "../common/"
import "../common/gameFunctions.js" as Fun
import "../common/bigInteger.js" as Big

SceneBase {
    id: levelBase //zuvor gameScene

    signal backButtonPressed

    //logical game size which is auto scaled
    width: gameWindow.logicalWidth
    height: gameWindow.logicalHeight

    //Spiele Optionen.
    property string levelID
    property int newTilesPerMove: 1

    property int gridWidth: width - 20
    property int gridSizeHeight: 2
    property int gridSizeWidth: value
    property int gridSizeGame: gridSizeHeight * gridSizeWidth
    //gridSizeGame war davor die größe eines einzelnen
    //property int gridSizeGameSquared: gridSizeGame * gridSizeGame //Noch auskommentieren
    property var emptyCells: []
    property var tileItems: new Array(gridSizeGame)

    property string Score: "0"
    property string highscore: "0"
    //Zum wiederherstellen des letzten Zustandes
    //Muss den Zustand des Spielfeldes beinhalten und den letzten Highscore
    property var restoreStr

    BubbleBackground {}

    ShadowText {
        id: bestScore
        text: "Best Score: " + highscore
        pixelSize: 15
        anchors.top: levelBase.top
        anchors.right: scoreText.right
    }

    ShadowText {
        id: scoreText
        text: levelBase.score
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

    /* TODO
     * Hier wird das "Bild" für den Hintergrund gesetzt. Das soll später eher
     * von der erbenden QML Klasse, also dem einzelnen Level erledigt werden
     */
    Item {
        id: gameContainer
        width: levelBase.gridWidth
        height: width
        anchors.centerIn: parent
        GameBackground {}
    }

    Timer {
        id: moveRelease
        interval: 100
    }

    /* Spiel Steuerung
     * Für das Spielen mit einer Tastatureingabe
     * Später bei Hexfeldern ist diese art der Steuerung dan nicht mehr möglich
      */
    Keys.forwardTo: keyboardController
    Item {
        id: keyboardController

        Keys.onPressed: {
            if (!system.desktopPlatform) return
            if (event.key === Qt.Key_Left && moveRelease.running === false) {
                event.accepted = true
                levelBase.moveLeft()
                moveRelease.start()
            } else if (event.key === Qt.Key_Right && moveRelease.running === false) {
                event.accepted = true
                levelBase.moveRight()
                moveRelease.start()
            } else if (event.key === Qt.Key_Up && moveRelease.running === false) {
                event.accepted = true
                levelBase.moveUp()
                moveRelease.start()
            } else if (event.key === Qt.Key_Down && moveRelease.running === false) {
                event.accepted = true
                levelBase.moveDown()
                moveRelease.start()
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: levelBase.gameWindowAnchorItem

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
                        levelBase.moveRight()
                        moveRelease.start()
                    } else if (deltaX < -30 && Math.abs(deltaY) < 30 && moveRelease.running === false) {
                        levelBase.moveLeft()
                        moveRelease.start()
                    } else if (deltaY > 30 && Math.abs(deltaX) < 30 && moveRelease.running === false) {
                        levelBase.moveDown()
                        moveRelease.start()
                    } else if (deltaY < -30 && Math.abs(deltaX) < 30 && moveRelease.running === false) {
                        levelBase.moveUp()
                        moveRelease.start()
                    }
                }
            }
        }
    }

    BackButton {
        x: 10
        y: 10
        onClicked: {
            Fun.saveGame()
            Fun.saveHighscore()
            backButPressed()
        }
    }

    Button2048 {
        id: resetButton
        anchors.left: gameContainer.left
        anchors.bottom: gameScene.bottom
        anchors.bottomMargin: 10
        onClicked: {
            //TODO Lösche den gespeicherten Spielstand und setze das Spielfeld neu auf
            //localStorage.clearValue("savedGame" + gridSizeGame)

            //Speicher bei Bedarf den aktuellen Highscore
            //Fun.saveHighscore(); setUpGame(gridSizeGame);
        }
        text: "Restart"
    }

    /* TODO Dieser Button soll nicht uneingeschränkt immer verfügbar sein
     * Füge einen Counter ein, der anzeigt wie häufig noch resetet werden kann
     */
    Button2048 {
        id: undoButton
        anchors.right: gameContainer.right
        anchors.bottom: resetButton.bottom
        onClicked: {
            //if (restoreStr !== undefined) restore(restoreStr)
        }
        text: "Undo"
    }

    Component.onCompleted: {
        setUpGame(levelID)
    }

    //TODO GameOver Popup einfügen


    /* Konfiguriere das Level anhand seiner ID
     * Lade dazu den Kofigurationsstring
     *
    */
    function setUpGame(levelID) {
        //TODO Lade hier die Kofigutation eines Levels

        //Lade hier den letzten Spielstand, falls dieser existiert
        loadGame(levelID)

        //TODO Lade den persönlichen besten Highscore
    }

    /* TODO
     * Lade den letzten Spielstand, falls es einen gespeicherten Spielstand gibt
     * return true if game is loaded, false otherwise
    */
    function loadGame(levelID) {
        //TODO
    }

    /* TODO
     * Benutze den restoreStr zum wiederherstellen
    */
    function restore(restoreString) {
        //TODO
    }

    //extract and save emptyCells from tileItems
    function updateEmptyCells() {
        emptyCells = []
        for (var i = 0; i < gridSizeGame; i++) {
            if (tileItems[i] === null) {
                emptyCells.push(i)
            }
        }
    }

    //creates new tile at random index
    //positioning and value setting happens inside the tile class
    //TODO überarbeiten!
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
        Fun.saveHighscore()
        //Reseten des Spielfeldes erst wenn der Spieler bestätigt hat
        //Popup zeigen, dass gameOver ist
    }

    function merge(sourceRow) {
        var i, j
        var nonEmptyTiles = [] //sourceRow without empty tiles
        var indices = []

        //TODO Sobald es nicht bewegliche Blöcke gibt muss hier eine Änderung für diese
        //implemetiert werden
        //remove zero/empty elements
        for (i = 0; i < sourceRow.length; i++) {
            indices[i] = nonEmptyTiles.length
            if (sourceRow[i] !== "") {
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
                //Und die Teile müssen bigInts sein
                if ((nonEmptyTiles[i] === nonEmptyTiles[i + 1]) && (Big.isBigInt(nonEmptyTiles[i]))) {
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

        for (i = 0; i < gridSizeHeight; i++) {
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
                        //TODO hier sollte die Funktion nur rein springen
                        if (mergedRow[indices[j]] > sourceRow[j] && tileItems[gridSizeHeight * i + indices[j]] !== null) {
                            //Move, merge and increment value of the merged element
                            //increment the value of the tile that got merged
                            if (isBigInt) {

                            }

                            tileItems[gridSizeHeight * i + indices[j]].tileValue++ //TODO TODO TODO
                            //move second tile in the merge direction
                            tileItems[gridSizeHeight * i + j].moveTile(gridSizeHeight * i + indices[j])
                            //and destroy it
                            tileItems[gridSizeHeight * i + j].destroyTile()
                        } else {
                            //Move only
                            tileItems[gridSizeHeight * i + j].moveTile(gridSizeHeight * i + indices[j])
                            tileItems[gridSizeHeight * i + indices[j]] = tileItems[gridSizeHeight * i + j]
                        }
                        tileItems[gridSizeHeight * i + j] = null
                    }
                }
            }
        }

        if (isMoved) moveFinished(curState)
    }

    function moveRight() {
        var isMoved = false
        var sourceRow, mergedRow, merger, indices
        var i, j, k //k used for reversing
        var curState = saveCurrentState();

        for (i = 0; i < gridSizeHeight; i++) {
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
                        if (mergedRow[indices[k]] > sourceRow[k] && tileItems[gridSizeHeight * i + indices[k]] !== null) {
                            // Move and merge
                            tileItems[gridSizeHeight * i + indices[k]].tileValue++
                            tileItems[gridSizeHeight * i + k].moveTile(gridSizeHeight * i + indices[k])
                            tileItems[gridSizeHeight * i + k].destroyTile()
                        } else {
                            // Move only
                            tileItems[gridSizeHeight * i + k].moveTile(gridSizeHeight * i + indices[k])
                            tileItems[gridSizeHeight * i + indices[k]] = tileItems[gridSizeHeight * i + k]
                        }
                        tileItems[gridSizeHeight * i + k] = null
                    }
                }
            }
        }

        if (isMoved) moveFinished(curState)
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

        if (isMoved) moveFinished(curState)
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

        if (isMoved) moveFinished(curState)
    }

    function moveFinished(curState) { //Done
        updateEmptyCells()
        for (var i = 0; i < newTilesPerMove; i++) {
            createNewTile()
        }
        restoreStr = curState
    }

    function getColumnAt(index) { //Done
        var column = []
        for (var j = 0; j < gridSizeHeight; j++) {
            //if there are no tileItems at this spot, push("") to the column, else push the tileIndex value
            if (tileItems[index + j * gridSizeWidth] === null) {
                column.push("")
            } else {
                column.push(tileItems[index + j * gridSizeWidth].tileValue)
            }
        }
        return column
    }

    function getRowAt(index) { //Done
        var row = []
        for (var j = 0; j < gridSizeWidth; j++) {
            //if there are no tileItems at this spot, push("") to the row, else push the tileIndex value
            if (tileItems[j + index * gridSizeHeight] === null) {
                row.push("")
            } else {
                row.push(tileItems[j + index * gridSizeHeight].tileValue)
            }
        }
        return row
    }

    function arraysIdentical(a, b) { //Done
        var i = a.length
        if (i !== b.length) return false
        while (i--) {
            if (a[i] !== b[i]) return false
        }
        return true
    }

}
