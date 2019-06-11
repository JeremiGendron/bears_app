async function usernameInUse(username, dynamoDB) {
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

module.exports = usernameInUse