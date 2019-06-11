const aws = require('aws-sdk')
const dynamoDB = new aws.DynamoDB()

exports.handler = async (event) => {
    const { email, confirmationNumber } = event

    let calls = []

    if (!user) {
        calls.push(clearUser(email))
        //calls.push(clearEmail(email))
        //calls.push(clearUsername(username))
        //calls.push(clearConfirmationNumber(confirmationNumber))
        await Promise.all(calls)
    }

    return
}

async function clearConfirmationNumber(confirmationNumber) {
    const params = {
        TableName: 'bg-Confirms',
        Key: {
            confirmationNumber: { S: confirmationNumber }
        },
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.deleteItem(params).promise()
        return
    }
    catch(e) {
        console.log(e)
        return
    }
}

async function clearUsername(username) {
    const params = {
        TableName: 'bg-Usernames',
        Key: {
            username: { S: username }
        },
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.deleteItem(params).promise()
        return
    }
    catch(e) {
        console.log(e)
        return
    }
}

async function clearEmail(email) {
    const params = {
        TableName: 'bg-Emails',
        Key: {
            email: { S: email }
        },
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.deleteItem(params).promise()
        return
    }
    catch(e) {
        console.log(e)
        return
    }
}

async function clearUser(email) {
    const user = await getUser(email)
    if (user) return

    const params = {
        TableName: 'bg-Users',
        Key: {
            email: { S: email }
        },
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.deleteItem(params).promise()
        return
    }
    catch(e) {
        console.log(e)
        return
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
        const result = await dynamoDB.getItem(params).promise()
        if (result.Item && result.Item.registered && result.Item.registered.BOOL === true) return true
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}