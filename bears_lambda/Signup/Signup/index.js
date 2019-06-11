const aws = require('aws-sdk')

const validate = require('./validate')
const getConfirmationNumber = require('./getConfirmationNumber')
const { emailRegistered, usernameInUse, tooYoung, tokenInvalid } = require('./stages/1')
const { getToken, registerUser, sendConfirmationEmail } = require('./stages/2')
const { errors, badRequest, internalError, success } = require('./responses')

const dynamoDB = new aws.DynamoDB()
const ses = new aws.SES()

exports.handler = async (event) => {
    const { email, username, dateOfBirth, password, token } = JSON.parse(event.body)

    if (!validate(email, username, dateOfBirth)) return badRequest

    try {
        const calls = [
            emailRegistered(email, dynamoDB),
            usernameInUse(username, dynamoDB),
            tooYoung(dateOfBirth),
            tokenInvalid(token)
        ]

        const results = await Promise.all(calls)
        
        let error;

        results.forEach((invalid, index) => {
            console.log('stage1: ', invalid, index)
            if (invalid === true) error = index
            else if (invalid === null) error =  'internalError'
            else if (typeof invalid == 'object') error = invalid
        })

        if (typeof error == 'object') return error

        if (typeof error == 'number') return errors[error]
        else if (typeof error == 'string' && error == 'internalError') return internalError

        const confirmationNumber = getConfirmationNumber()

        const wrapup = [
            getToken(email, username, dateOfBirth, confirmationNumber, dynamoDB),
            registerUser(email, username, dateOfBirth, password, confirmationNumber, dynamoDB),
            sendConfirmationEmail(email, username, confirmationNumber, ses)
        ]

        const done = await Promise.all(wrapup)
        
        done.forEach((invalid, index) => {
            console.log('stage2: ', invalid, index)
            if (invalid === true) error = index
            else if (typeof invalid == 'object') error = invalid
            else if (invalid === null) error =  'internalError'
        })

        if (typeof error == 'number') return errors[error + 4]
        else if (typeof error == 'object') return error
        else if (typeof error == 'string' && error == 'internalError') return internalError

        return success(done[0])

    }
    catch(e) {
        console.log(typeof sendConfirmationEmail, Object.keys(sendConfirmationEmail))
        console.log(e)
        return internalError
    }
}





