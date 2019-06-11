async function sendConfirmationEmail(email, username, confirmationNumber, ses) {
    const params = {
        Source: 'do not reply <no-reply@mailtor.co>',
        Destination: {
          ToAddresses: [
            email
          ],
        },
        Message: {
            Subject: {
                Data: '(content creator) Confirm Registration',
                Charset: 'UTF-8'
            },
            Body: {
                Text: {
                    Data: textTemplate({ username, confirmationNumber }),
                    Charset: 'UTF-8'
                },
                Html: {
                    Data: htmlTemplate({ username, confirmationNumber }),
                    Charset: 'UTF-8'
                }
            }
        }

    }

    try {
        await ses.sendEmail(params).promise()
        return false
    }
    catch(e) {
        console.log(e)
        return null
    }
}

const htmlTemplate = ({ confirmationNumber }) => `
<div>
    <div
        style="width: 100%; background-color: #3490dc; display: flex; align-items: center;"
    >
        <img src="https://s3.amazonaws.com/content-creator-assets/logo.png" style="height: 8vh; margin-left: 1vh; margin-right: 1vh;" />
    
    </div>
    <div
        style="padding: 2vh; background-color: white;"
    >
        <span style="font-size: 3vh; font-weight: bold; margin-left: 2vh; margin-top: 2vh;">${confirmationNumber}</span>
        <span style="margin-left: 1vh; font-size: 2.5vh"> is your code.</span> 
        <p style="font-size: 2.5vh">We hope to see you soon!</p>
    </div>
    <div
        style="background-color: navy; width: 100%; padding: 2vh;"
    >
        <span style="color: white;  font-size: 1.8vh; font-weight: bold;">
            © Content Creator | 2019 ${new Date().getFullYear() > 2019 ? '- ' + new Date().getFullYear().toString() : ''}
        </span>
    
    </div>

</div>`

const textTemplate = ({ confirmationNumber }) => 
`Hello! Your request for a new account for the contentcreator app has been received. Please confirm your account by entering the code below on the 'Confirm' screen of the app.

${confirmationNumber}

Welcome to the community!`

module.exports = sendConfirmationEmail