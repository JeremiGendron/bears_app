//const saveToUsernames = require('./saveToUsernames')
const saveToUsers = require('./saveToUsers')
const saveToConfirms = require('./saveToConfirms')
const invokeDeleteAfterHour = require('./invokeDeleteAfterHour') 

const internalError = require('../../../responses/internalError')

async function registerUser(email, username, dateOfBirth, password, confirmationNumber, dynamoDB) {
    const calls = [
        //saveToUsernames(username, dynamoDB),
        saveToUsers(email, username, dateOfBirth, password, dynamoDB),
        //saveToConfirms(email, username, dateOfBirth, confirmationNumber, dynamoDB),  
        invokeDeleteAfterHour(email, confirmationNumber) // invoke step function
    ]

    const results = await Promise.all(calls)

    let error;

    results.forEach((invalid, index) => {
        if (invalid === true) error = index
        else if (invalid === null) error =  'internalError'
    })

    if (typeof error == 'number') return userRegistrationErrors[error]
    else if (typeof error == 'string' && error == 'internalError') return internalError

    return false
}

const userRegistrationErrors = [
    {
        isBase64Encoded: false,
        statusCode: 415, // saveToUsernames
        body: null
    },
    {
        isBase64Encoded: false,
        statusCode: 416, // saveToUsers
        body: null
    },
    {
        isBase64Encoded: false,
        statusCode: 417, // saveToConfirms
        body: null
    },
    {
        isBase64Encoded: false,
        statusCode: 418, // invokeDeleteAfterHour
        body: null
    },
]

module.exports = registerUser