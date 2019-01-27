//TODO
/* Hier muss die ID des levels mit übergeben werden und ob es sich um ein Level
  *oder ein Standart 2048 handelt
  * levelID = ID wenn Level sonst größe Feld, isLevel, isGameOver
  */
function saveGame(levelID, isLevel, isGameOver) {
    //bisheriger Aufbau der Save Funktion.
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

    //Hier wird auf den localen Storage zugegriffen. Vllt muss hier später noch was geändert werden
    localStorage.setValue(key, saveArray)

    //TODO speicher den highscore
    saveHighscore(levelID, isLevel)
}

//TODO
/*  Hier muss die ID des levels mit übergeben werden und ob es sich um ein Level
  * oder ein Standart 2048 handelt
  * levelID = ID wenn Level sonst größe Feld, isLevel
  */
function saveHighscore(levelID, isLevel) {

}
