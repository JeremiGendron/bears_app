const uuidv4 = require('uuid/v4')
const aws = require('aws-sdk')
const dynamoDB = new aws.DynamoDB()
const validate = require('./validate')
const errors = require('./errors')

exports.handler = async (event) => {
    try {
        const { email, token, username, dateOfBirth, code } = JSON.parse(event.body)

        if (!validate(email, token, username, dateOfBirth, code)) return badRequest

        const calls = [
            emailRegistered(email),
            usernameInUse(username),
            tokenInvalid(token, email, username, dateOfBirth, code)
        ]

        const results = await Promise.all(calls)

        let error;

        results.forEach((result, index) => {
            if (result) error = errors[index]
            else if (result == null) error = internalError
            else if (typeof result == 'object') error = result
        })

        if (error) return error

        const userId = uuidv4()

        const wrapup = [
            deleteToken(token),
            saveUser(userId, email, username),
            newToken(userId, email)
        ]

        const done = await Promise.all(wrapup)
        error = null;

        done.forEach(result => {
            if (typeof result)
            if (result == null) error = internalError
        })

        if (error) return error

        return {
            isBase64Encoded: false,
            statusCode: 200,
            body: JSON.stringify({
                userId,
                token: done[2]
            }),
            headers: {
                'Content-Type': 'application/json'
            }
        }
    }
    catch(e) {
        console.log(e)
        return internalError
    }
}

async function deleteToken(token) {
    const params = {
        TableName: 'bg-Tokens',
        Key: {
            token: { S: token }
        },
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.deleteItem(params).promise()
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

async function newToken(userId, email) {
    const token = uuidv4()

    const params = {
        TableName: 'bg-Tokens',
        Item: {
            token: { S: token },
            action: { S: 'login' },
            time: { S: Date.now().toString() },
            data: { S: JSON.stringify({ email, userId }) }
        }
    }

    try {
        await dynamoDB.putItem(params).promise()
        return token    
    }
    catch(e) {
        console.log(e)
        return null;
    }

}

async function saveUser(uuid, email, username) {
    const calls = [
        updateRegistered(email, uuid),
        registerUsername(username),
    ]

    try {
        let error
        const results = await Promise.all(calls)
        results.forEach(result => {
            if (result == null) error = true
        })

        if (error === true) return null
        else return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

async function updateRegistered(email, userId) {
    const params = {
        TableName: 'bg-Users',
        Key: {
            email: { S: email }
        },
        ExpressionAttributeNames: {
            "#R": "registered",
            "#U": "userId"
        },
        ExpressionAttributeValues: {
            ":r": {
                BOOL: true
            },
            ":u": {
                S: userId
            }
        },
        UpdateExpression: "SET #R = :r, #U = :u",
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.updateItem(params).promise()
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}
async function registerUsername(username) {
    const params = {
        TableName: 'bg-Usernames',
        Item: {
            username: { S: username }
        },
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.putItem(params).promise()
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

async function tokenInvalid(token, email, username, dateOfBirth, code) {
    try {
        const calls = [
            getToken(token),
            getUser(email)
        ]

        const results = await Promise.all(calls)
        
        let error;

        results.forEach((result, index) => {
            if (result == null) error = internalError
        })

        if (error === 'internalError') return internalError
        if (error === true) return true

        const tokenData = results[0]
        const userData = results[1]

        if (userData.registered === true) return errors[0]

        if (tokenData.action !== 'confirm') return badToken
        if (tokenData.data.code !== code) return badToken
        if (tokenData.data.username !== username) return badToken
        if (tokenData.data.email !== email) return badToken
        if (tokenData.data.dateOfBirth !== dateOfBirth) return badToken
        
        if (userData.dateOfBirth !== dateOfBirth) return badToken
        if (userData.username !== username) return badToken

        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

async function getToken(token) {
    const params = {
        TableName: 'bg-Tokens',
        Key: {
            token: { S: token }
        }
    }

    try {
        const response = await dynamoDB.getItem(params).promise()
        if (response.Item && response.Item.token && response.Item.token.S) return {
            time: response.Item.time.S,
            data: JSON.parse(response.Item.data.S),
            action: response.Item.action.S
        }
        return true
    }
    catch(e) {
        console.log(e)
        return null
    }
}

async function getUser(email) {
    const params = {
        TableName: 'bg-Users',
        Key: {
            email: { S: email }
        }
    }

    try {
        const response = await dynamoDB.getItem(params).promise()
        if (response.Item && response.Item.email && response.Item.email.S) return {
            joinDate: response.Item.joinDate.S,
            dateOfBirth: response.Item.dateOfBirth.S,
            username: response.Item.username.S,
            registered: response.Item.registered.BOOL
        }
        return true
    }
    catch(e) {
        console.log(e)
        return null
    }
}

async function emailRegistered(email) {
    const params = {
        TableName: 'bg-Users',
        Key: {
            email: { S: email }
        },
        ExpressionAttributeNames: {
            "#R": "registered"
        },
        ProjectionExpression: "#R"
    }

    try {
        const response = await dynamoDB.getItem(params).promise()
        if (response.Item && response.Item.registered && response.Item.registered.BOOL === true) return true
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

async function usernameInUse(username) {
    const params = {
        TableName: 'bg-Usernames',
        Key: {
            username: { S: username }
        }
    }
    try {
        const response = await dynamoDB.getItem(params).promise()
        if (response.Item && response.Item.username && response.Item.username.S) return true
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

const badRequest = {
    isBase64Encoded: false,
    statusCode: 400,
    body: null
}

const internalError = {
    isBase64Encoded: false,
    statusCode: 500,
    body: null
}

const badToken = {
    isBase64Encoded: false,
    statusCode: 411,
    body: "Bad token."
}