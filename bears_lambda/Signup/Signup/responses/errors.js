const errors = [
    {
        isBase64Encoded: false,
        statusCode: 409, // emailRegistered
        body: null
    },
    {
        isBase64Encoded: false,
        statusCode: 410, // usernameInUse
        body: null
    },
    {
        isBase64Encoded: false,
        statusCode: 411, // tooYoung
        body: null
    },
    {
        isBase64Encoded: false, // tokenInvalid
        statusCode: 412,
        body: null
    },
    {
        isBase64Encoded: false,
        statusCode: 413, // getToken
        body: null    
    },
    null, // not needed (uses 414, 415, 416, 417, 418)
    {
        isBase64Encoded: false,
        statusCode: 419, // sendConfirmationEmail
        body: null
    },
]

module.exports = errors