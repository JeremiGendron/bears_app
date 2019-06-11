const emailRegExp = /(\D)+(\w)*((\.(\w)+)?)+@(\D)+(\w)*((\.(\D)+(\w)*)+)?(\.)[a-z]{2,}/
const usernameRegExp = /[a-z0-9_]{3,25}/
const dobRegExp = /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/

function validate(email, username, dateOfBirth) {
    console.log("email: ", emailRegExp.test(email))
    console.log("username: ", usernameRegExp.test(username))
    console.log("dob: ", dobRegExp.test(dateOfBirth))
    console.log(email, username, dateOfBirth, typeof dateOfBirth)
    return emailRegExp.test(email) && usernameRegExp.test(username) && dobRegExp.test(dateOfBirth)
}

module.exports = validate