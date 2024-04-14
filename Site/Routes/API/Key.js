const Express                           = require("express")
const FileSystem                        = require("fs")
const Path                              = require("path")
const Axios                        		= require("axios")

const Linker                            = require(Path.join(__dirname, "../", "../", "../", "Main", "Data", "Linker"))
const Database                         	= require(Path.join(__dirname, "../", "../", "../", "Main", "Schemas", "Data"))
const Config                         	= require(Path.join(__dirname, "../", "../", "../", "Config"))

const Router 							= Express.Router()
const Stages 							= {
	[1]: "https://direct-link.net/973576/fondra",
	[2]: "https://direct-link.net/973576/fondra-stage-2",
}

Router.use((Request, Respond, Next) => {
	Next()
})

Router.all("/Key/:Identifier", async (Request, Respond) => {
    const Method                        = Request.method
    const Params                        = Request.params

    if (!Method) return Respond.json({ ["Code"]: "MC-01" })
    if (Method != "GET") return Respond.json({ ["Code"]: "MC-02" })
	if (Params.Identifier && Params.Identifier !== "Gateway" && Params.Identifier !== "Failed") Respond.cookie("Identifier", Params.Identifier, { maxAge: 0.5 * 60 * 60 * 1000, httpOnly: true })

	Params.Identifier					= Request.cookies.Identifier || Params.Identifier

    if (!Params) return Respond.json({ ["Code"]: "PC-01" })
	if (!Params.Identifier) return Respond.json({ ["Code"]: "PC-02" })

    if (!/^[a-zA-Z0-9]+$/.test(Params.Identifier)) return Respond.json({ ["Code"]: "SC-01" })

    let Data 						    = await Database.findById(Params.Identifier).catch(function(Error) {})
	let Time 							= Date.now() / 1000
    
    if (!Data) return Respond.json({ ["Code"]: "ID-00" })
    if (!Time) return Respond.json({ ["Code"]: "IT-00" })

    var Refresh							= await Axios.post("https://discord.com/api/v10/oauth2/token", {
		client_id: Config.Bot.ID,
		client_secret: Config.Bot.Secret,

		grant_type: "refresh_token",
		refresh_token: Data.Refresh
	}, {
		headers: {
			["Content-Type"]: "application/x-www-form-urlencoded"
		}
	}).catch(function(Error) {})

	if (!Refresh) return Respond.json({ ["Code"]: "NA-00" })
	if (!Refresh.data) return Respond.json({ ["Code"]: "NA-00" })

	Data.Access                         = Refresh.data.access_token
    Data.Refresh                        = Refresh.data.refresh_token

	await Data.save()

	Data.markModified("Key")

	if (Time - Data.Key.Last <= 15) { Data.Key.Last = Time; await Data.save(); return Respond.redirect("https://link-center.net/973576/fondra-failed-redirect") }
	if (Time - Data.Key.Generated <= 18000) return Respond.end("You may now re-run Fondra! It will automatically detect your key and let you load in!")
	
	Data.Key.Stage 						= Data.Key.Stage && Data.Key.Stage + 1 || 1
	Data.Key.Last 						= Time

	if (Data.Key.Stage >= 3) {
		Data.Key.Stage 					= 0
		Data.Key.Last 					= 0
		Data.Key.Generated 				= Time

		await Data.save()

		return Respond.end("You may now re-run Fondra! It will automatically detect your key and let you load in!")
	}

	await Data.save()

	Respond.redirect(Stages[Data.Key.Stage])
})

module.exports 							= Router