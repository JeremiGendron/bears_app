function success(token) {
    return {
        isBase64Encoded: false,
        statusCode: 200,
        body: token,
        headers: {
            'Content-Type': "text/plain"
        }
    }
}

module.exports = success