function createBigInt(int) {
    return int.toString()
}

function addTwoBigInt(one, two) {
    //Festlegen der längeren und der kürzeren Zahl
    var long = one.length > two.length ? one : two
    var short = one.length > two.length ? two : one

    var dif = Math.abs(one.length - two.length)
    var carry = 0

    for (var i = long; i > 0; i--) {

    }
}
