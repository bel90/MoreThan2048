function createBigInt(int) {
    return int.toString()
}

function addTwoBigInt(one, two) {
    //Festlegen der längeren und der kürzeren Zahl
    var long = one.length > two.length ? one : two
    var short = one.length > two.length ? two : one

    var dif = Math.abs(one.length - two.length)
    var carry = 0

    var ret = ""
    var tmp;

    for (var i = long.length -1; i >= 0; i--) {
        //Bereche die Summe:
        if ((i - dif) > -1) {
            tmp = parseInt(long.charAt(i)) + parseInt(short.charAt(i - dif)) + carry
        } else {
            tmp = parseInt(long.charAt(i)) + carry
        }
        ret = (tmp % 10).toString() + ret
        carry = Math.floor(tmp / 10)
    }
    if (carry > 0) {
        ret = carry + ret
    }

    return ret;
}

function powBigInt(bigInt) {
    return addTwoBigInt(bigInt, bigInt)
}

function bigIntToTile(bigInt) {
    if (bigInt.length < 6) {
        return bigInt
    } else if (bigInt.length < 8) {
        return bigInt.slice(0, bigInt.length - 3) + "K";
    } else if (bigInt.length < 11) {
        return bigInt.slice(0, bigInt.length - 6) + "M";
    }
    var toLarge = "to Large"
    return toLarge
}

function isBigInt(bigInt) {
    var tmp
    for (var i = 0; i < bigInt.length; i++) {
        tmp = bigInt.charCodeAt(i)
        if ((tmp < 48) || (57 < tmp)) {
            return false
        }
    }
    return true
}
