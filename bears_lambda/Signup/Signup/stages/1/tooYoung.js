async function tooYoung(dateOfBirth) {
    dateOfBirth = new Date(`${dateOfBirth}T00:00:00.000Z`).getTime()
    const maximum = Date.now() - 1000 * 60 * 60 * 24 * 365 * 13
    console.log(dateOfBirth, maximum, maximum - dateOfBirth)
    if (dateOfBirth > maximum) return true
    return false
}

module.exports = tooYoung