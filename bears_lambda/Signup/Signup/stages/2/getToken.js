const uuidv4 = require('uuid/v4')

async function getToken(email, username, dateOfBirth, confirmationNumber, dynamoDB) {
    const token = uuidv4()

    const params = {
        TableName: 'bg-Tokens',
        Item: {
            token: { S: token },
            action: { S: 'confirm' },
            time: { S: Date.now().toString() },
            data: { S: JSON.stringify({ email, username, dateOfBirth, confirmationNumber }) }
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

module.exports = getToken