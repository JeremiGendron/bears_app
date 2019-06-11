const axios = require('axios')
const fetch = require('node-fetch')
const secret = '6LfAjaYUAAAAAPtNqugyZaNqfVA3JnAnCNVUn253'
const captcha_hostname = 'jeremigendron.com'

const url = 'https://www.google.com/recaptcha/api/siteverify'

async function tokenInvalid(token) {

    try {
        const response = await fetch(url + `?secret=${secret}&response=${token}`, {
            method: 'POST'
        })
        const json = await response.json()
        console.log(json)
        if (!json.success || typeof json.challenge_ts !== 'string' || json.action != 'signup' ||
            Date.now() - new Date(json.challenge_ts).getTime() > 1000 * 60 * 3 ||
            json.hostname != captcha_hostname || json.score < 0.6
        ) return true
        return false
    } catch(e) {
        console.log(e)
        return null
    }
}

module.exports = tokenInvalid