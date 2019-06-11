const aws = require('aws-sdk')
const dynamoDB = new aws.DynamoDB()

const regExp = /(\D)+(\w)*((\.(\w)+)?)+@(\D)+(\w)*((\.(\D)+(\w)*)+)?(\.)[a-z]{2,}/;

exports.handler = async (event) => {
    try {
        if (!regExp.test(event.body)) return badRequest()
        const params = {
            TableName: 'bg-Emails',
            Key: {
                email: { S: event.body }
            }
        }
        const result = await dynamoDB.getItem(params).promise()
        if (result.Item && result.Item.email && result.Item.email.S) {
            if (await checkRegistered(email)) return emailUsed()
            else return unconfirmed()
        }
        else return emailAvailable()
    }
    catch (error) {
        return internalError()
    }
}

async function checkRegistered(email) {
    const params = {
        TableName: 'bg-Users',
        Key: {
            email: { S: email }
        }
    }

    try {
        const result = await dynamoDB.getItem(params).promise()
        if (result.Item && result.Item.registered && result.Item.registered.BOOL == true) return true
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

function unconfirmed() {
    return {
        isBase64Encoded: false,
        statusCode: 410, // email is linked to an unconfirmed account, show confirm button on frontend
        body: null
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
function emailUsed() {
    return {
        isBase64Encoded: false,
        statusCode: 409, // email is used, show error on frontend
        body: null
    }
}
function emailAvailable() {
    return {
        isBase64Encoded: false,
        statusCode: 200,
        body: null
    }
}