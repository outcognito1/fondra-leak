const FileSystem                        = require("fs")
const Express                           = require("express")
const Path                              = require("path")
const Axios                        		= require("axios")

const Database                         	= require(Path.join(__dirname, "../", "../", "../", "Main", "Schemas", "Data"))
const Executions                        = require(Path.join(__dirname, "../", "../", "../", "Main", "Data", "Executions"))
const Config                         	= require(Path.join(__dirname, "../", "../", "../", "Config"))

let Total 								= Executions

const Router 							= Express.Router()
const Connected 						= new Map()

process.on("SIGINT", async () => {
	FileSystem.writeFileSync(Path.join(__dirname, "../", "../", "../", "Main", "Data", "Executions.json"), JSON.stringify(Total), "utf8")
})

Router.use((Request, Respond, Next) => {
	Next()
})

Router.ws("/Telemetry/:Key/:Name", async (WS, Request) => {
	const Method                        = Request.method
    const Headers                       = Request.headers
    const Params                        = Request.params

    if (!Method) { WS.send(JSON.stringify({ Code: "MC-01" })); WS.close(); return }
    if (Method != "GET") { WS.send(JSON.stringify({ Code: "MC-02" })); WS.close(); return }

    if (!Params) { WS.send(JSON.stringify({ Code: "PC-01" })); WS.close(); return }
    if (!Params.Key) { WS.send(JSON.stringify({ Code: "PC-02" })); WS.close(); return }
    if (!Params.Name) { WS.send(JSON.stringify({ Code: "PC-03" })); WS.close(); return }

	if (Connected.has(Params.Key)) {
		Connected.get(Params.Key).Socket.close()
	}
	
	if (!/^[a-zA-Z0-9]+$/.test(Params.Key)) { WS.send(JSON.stringify({ Code: "PC-04" })); WS.close(); return }
	if (!/^[a-zA-Z0-9_]+$/.test(Params.Name)) { WS.send(JSON.stringify({ Code: "PC-05" })); WS.close(); return }
	if (Params.Name.length < 3 || Params.Name.length > 20) { WS.send(JSON.stringify({ Code: "PC-06" })); WS.close(); return }

	const Data 							= await Database.findById(Params.Key).catch(function(Error) {})

	if (!Data) { WS.send(JSON.stringify({ Code: "DNF-00" })); WS.close(); return }

	var User							= await Axios.get("https://discord.com/api/v10/users/@me", {
		headers: { 
			["Authorization"]: `Bearer ${Data.Access}` 
		}
	}).catch(function(Error) {})

	if (!User) { WS.send(JSON.stringify({ Code: "RF-00" })); WS.close(); return }

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

	if (!Refresh) { WS.send(JSON.stringify({ Code: "RF-00" })); WS.close(); return }

	Data.User 							= User.data.username
	Data.Access                         = Refresh.data.access_token
    Data.Refresh                        = Refresh.data.refresh_token
	Total								+= 1

	const Timer 						= setInterval(() => {
		if (WS.readyState === WS.OPEN) {
			WS.send(JSON.stringify({ Code: "AD-00" }))
		}
	 }, 90000)

	await Data.save()

	Connected.set(Params.Key, {
		Active: false,
		Socket: WS,
		Name: Params.Name,
		Key: Params.Key
	})

	const Users 						= Array.from(Connected.values())
	.filter((Client) => Client.Key != Params.Key)
	.filter((Client) => Client.Active != false)
	.map((Client) => Client.Name)

	WS.send(JSON.stringify({ Code: "CS-00", Clients: Users, Active: Connected.size, Executions: Total }))

	WS.on("message", (Data) => {
		var Data  						= Data.toLowerCase() === "true"

		if (Data) {
			for (const [Identifier, Data] of Connected) {
				if (WS != Data.Socket) {
					Data.Socket.send(JSON.stringify({ Code: "NU-00", Client: Params.Name, Active: Connected.size, Executions: Total }))
				}
			}
		} 
		
		if (!Data) {
			for (const [Identifier, Data] of Connected) {
				if (WS != Data.Socket) {
					Data.Socket.send(JSON.stringify({ Code: "RU-00", Client: Params.Name, Active: Connected.size, Executions: Total }))
				}
			}
		}
	})

	WS.on("close", () => {	
		for (const [Identifier, Data] of Connected) {
			if (WS != Data.Socket) {
				Data.Socket.send(JSON.stringify({ Code: "RU-00", Client: Params.Name }))
			}
		}

		clearInterval(Timer)
		Connected.delete(Params.Key)
	})
})

module.exports 							= Router