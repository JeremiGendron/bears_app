async function saveToUsers(email, username, dateOfBirth, password, dynamoDB) {
    const params = {
        TableName: 'bg-Users',
        Item: {
            email: { S: email }, 
            username: { S: username }, 
            dateOfBirth: { S: dateOfBirth }, 
            password: { S: password },
            joinDate: { S: Date.now().toString() },
            registered: { BOOL: false }
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

module.exports = saveToUsers