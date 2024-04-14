const Express                           = require("express")
const Path                              = require("path")
const Axios                        		= require("axios")
const Crypto							= require("crypto")

const Database                         	= require(Path.join(__dirname, "../", "../", "../", "Main", "Schemas", "Data"))
const Config                         	= require(Path.join(__dirname, "../", "../", "../", "Config"))

const Router 							= Express.Router()

Router.use((Request, Respond, Next) => {
	Next()
})

Router.all("/AuthO2", async (Request, Respond) => {
    const Method                        = Request.method
    const Headers                       = Request.headers
    const Query                        	= Request.query

    if (!Method) return Respond.json({ ["Code"]: "MC-01" })
    if (Method != "GET") return Respond.json({ ["Code"]: "MC-02" })

    if (!Query) return Respond.json({ ["Code"]: "QC-01" })
    if (!Query.code) return Respond.json({ ["Code"]: "QC-02" })

	var OAuth							= await Axios.post("https://discord.com/api/v10/oauth2/token", {
		code: Query.code.toString(),
		client_id: Config.Bot.ID,
		client_secret: Config.Bot.Secret,
		grant_type: "authorization_code",
		redirect_uri: "http://localhost:8080/API/AuthO2"
	}, {
		headers: {
			["Content-Type"]: "application/x-www-form-urlencoded"
		}
	}).catch(function(Error) {})

	if (!OAuth) return Respond.json({ ["Code"]: "RC-01" })
	
	var User							= await Axios.get("https://discord.com/api/v10/users/@me", {
		headers: { 
			["Authorization"]: `Bearer ${OAuth.data.access_token}` 
		}
	}).catch(function(Error) {})

	if (!User) return Respond.json({ ["Code"]: "RC-02" })

	var Refresh							= await Axios.post("https://discord.com/api/v10/oauth2/token", {
		client_id: Config.Bot.ID,
		client_secret: Config.Bot.Secret,

		grant_type: "refresh_token",
		refresh_token: OAuth.data.refresh_token
	}, {
		headers: {
			["Content-Type"]: "application/x-www-form-urlencoded"
		}
	}).catch(function(Error) {})

	if (!Refresh) return Respond.json({ ["Code"]: "RC-03" })

	var Refresh 						= Refresh.data
	var Output 							= OAuth.data
	var User 							= User.data

	let Original 						= await Database.findOne({ 
		ID: User.id
	})

	if (Original) {
		Original.Refresh				= Refresh.refresh_token
		Original.Access					= Refresh.access_token
	
		Original.User					= User.username
		Original.ID						= User.id

		await Original.save()

		return Respond.json({
			["Key"]: Original._id,
			["Data"]: "Already Existed"
		})
	}

	let Data 							= await Database.findOneAndUpdate({ 
		ID: User.ID
	}, {
		Refresh: Refresh.refresh_token,
		Access: Refresh.access_token,
	
		User: User.username,
		ID: User.id
	}, {
		upsert: true,
		new: true
	})

	if (Data) return Respond.json({
		["Key"]: Data._id,
		["Data"]: "Generated"
    })

    return Respond.json({ ["Code"]: "FTU-00" })
})

module.exports 							= Router