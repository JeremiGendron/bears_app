async function emailRegistered(email, dynamoDB) {
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
        console.log(response)
        if (response.Item && response.Item.registered && response.Item.registered.BOOL === true) return true
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }

}

const errors = {
    "badPassword": {
        isBase64Encoded: false,
        statusCode: 421,
        body: null
    },
    "unconfirmed":     {
        isBase64Encoded: false,
        statusCode: 420,
        body: null
    },
}

module.exports = emailRegistered

/**            let swappedUsername = false
            let passwordDifferent = false

            if (response.Item.password && response.Item.password.S !== password) passwordDifferent = true
            if (response.Item.username && response.Item.username.S !== username) {
                swappedUsername = true
                await dynamoDB.deleteItem({
                    TableName: 'bg-Usernames',
                    Key: {
                        username: { S: response.Item.username.S }
                    }
                }).promise()
            }

            if (passwordDifferent) return {
                statusCode: 421,
                body: response.Item.password.S
            }
            if (swapp) */