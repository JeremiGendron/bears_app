const aws = require('aws-sdk')
const dynamoDB = new aws.DynamoDB()

const regExp = /[a-z0-9_]{3,25}/

exports.handler = async (event) => {
    try {
        if (!regExp.test(event.body)) return badRequest()
        const params = {
            TableName: 'bg-Usernames',
            Key: {
                username: { S: event.body }
            }
        }
        const response = await dynamoDB.getItem(params).promise()
        if (response.Item && response.Item.username && response.Item.username.S) return usernameUsed()
        else return usernameAvailable()
    } 
    catch(error) {
        return internalError()
    }

}

function badRequest() {
    return {
        isBase64Encoded: false,
        statusCode: 400,
        body: null
    }
}
function internalError() {
    return {
        isBase64Encoded: false,
        statusCode: 500,
        body: null
    }
}
function usernameUsed() {
    return {
        isBase64Encoded: false,
        statusCode: 409,
        body: null
    }
}
function usernameAvailable() {
    return {
        isBase64Encoded: false,
        statusCode: 200,
        body: null
    }
}