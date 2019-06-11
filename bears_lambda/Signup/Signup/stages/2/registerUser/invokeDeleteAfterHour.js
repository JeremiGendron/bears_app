const uuidv4 = require('uuid/v4')
const aws = require('aws-sdk')
const stepFunctions = new aws.StepFunctions()

async function invokeDeleteAfterHour(email, username, confirmationNumber) {
    const data = JSON.stringify({email, username, confirmationNumber})
    const params = {
        stateMachineArn: 'arn:aws:states:us-east-1:127374084296:stateMachine:bg-SignupDeleteAfterHour',
        input: data,
        name: uuidv4()
    }

    try {
        await stepFunctions.startExecution(params).promise()
        return false
    }
    catch(e) {
        console.log(e)
        return null;
    }
}

module.exports = invokeDeleteAfterHour