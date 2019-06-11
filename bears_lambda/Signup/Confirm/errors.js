const errors = [
    {
        isBase64Encoded: false,
        statusCode: 420,
        body: 'Email in use.'
    },
    {
        isBase64Encoded: false,
        statusCode: 409,
        body: "Username in use."
    },
    {
        isBase64Encoded: false,
        statusCode: 410,
        body: "Bad token."
 
    }
]

module.exports = errors