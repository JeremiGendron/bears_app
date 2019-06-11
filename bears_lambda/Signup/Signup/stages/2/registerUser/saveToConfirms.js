async function saveToConfirms(email, username, dateOfBirth, confirmationNumber, dynamoDB) {
    const params = {
        TableName: 'bg-Confirms',
        Item: {
            email: { S: email },
            username: { S: username },
            dateOfBirth: { S: dateOfBirth },
            confirmationNumber: { S: confirmationNumber },
        },
        ReturnValues: 'NONE'
    }

    try {
        await dynamoDB.putItem(params).promise()
        return false
    } 
    catch (e) {
        console.log(e)
        return null    
    }
}

module.exports = saveToConfirms