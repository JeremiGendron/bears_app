async function saveToUsernames(username, dynamoDB) {
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
    catch (e) {
        console.log(e)
        return null;
    }
}

module.exports = saveToUsernames