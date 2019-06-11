function getRandomNumber(min, max) {
    min = Math.ceil(min)
    max = Math.floor(max)
    
    return Math.floor(Math.random() * (max - min + 1)) + min
}

function getConfirmationNumber() {
    let confirmationNumber = ''

    for (let i = 0; i < 7; i ++) {
        confirmationNumber += getRandomNumber(0, 9)
    }

    if (!confirmationNumber.includes('7')) {
        confirmationNumber = confirmationNumber.split('')
        confirmationNumber[getRandomNumber(0, 6)] = 7
        confirmationNumber = confirmationNumber.join('')
    }

    return confirmationNumber
}

module.exports = getConfirmationNumber