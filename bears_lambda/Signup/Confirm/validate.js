const uuidValid = require('uuid-validate')

const emailRegExp = /(\D)+(\w)*((\.(\w)+)?)+@(\D)+(\w)*((\.(\D)+(\w)*)+)?(\.)[a-z]{2,}/
const usernameRegExp = /[a-z0-9_]{3,25}/
const dobRegExp = /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/
const codeRegExp = /7/
function validate(email, token, username, dateOfBirth, code) {
    return emailRegExp.test(email) &&
        uuidValid(token, 4) &&
        usernameRegExp.test(username) &&
        dobRegExp.test(dateOfBirth) &&
        codeValid(code)
}

const codeValid = (code) => code.length == 7 && codeRegExp.test(code)

module.exports = validate