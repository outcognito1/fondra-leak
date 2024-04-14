const Express                           = require("express")
const Crypto                        	= require("crypto")
const Path                              = require("path")

const Router 							= Express.Router()

Router.use((Request, Respond, Next) => {
	Next()
})

Router.all("/HWID/:Verification", async (Request, Respond) => {
    const Method                        = Request.method
    const Headers                       = Request.headers
	const Params                        = Request.params
    const Executor                      = Headers["krampus-user-identifier"]

	if (!Method) return Respond.json({ ["Code"]: "MC-01" })
	if (Method != "GET") return Respond.json({ ["Code"]: "MC-02" })

	if (!Headers) return Respond.json({ ["Code"]: "HC-01" })
    if (!Executor) return Respond.json({ ["Code"]: "HC-02" })

	if (!Params) return Respond.json({ ["Code"]: "PC-01" })
	if (!Params.Verification) return Respond.json({ ["Code"]: "PC-02" })
	if (Params.Verification !== "572857461623094840743731288558") return Respond.json({ ["Code"]: "PC-02" })
	
	const Identifier 					= Crypto.randomBytes(5).toString("hex")
	const Code 							= ("game.Players.LocalPlayer:Kick('Fondra\\nIdentifier')").replace("Identifier", Identifier)
	const Log 							= ("Custom Code: Identifier\nHWID: Executor\n").replace("Identifier", Identifier).replace("Executor", Executor)

	Respond.send(Code)
})

Router.all("/Loader", async (Request, Respond) => {
    const Method                        = Request.method
    const Headers                       = Request.headers
    const Executor                      = Headers["krampus-user-identifier"]

	if (!Method) return Respond.json({ ["Code"]: "MC-01" })
    if (!Headers) return Respond.json({ ["Code"]: "HC-01" })

	if (Method != "GET") return Respond.json({ ["Code"]: "MC-02" })
    if (!Executor) return Respond.json({ ["Code"]: "HC-02" })

	Respond.sendFile(Path.join(__dirname, "../", "../", "../", "Main", "Loaders", "Handler", "Public Loader.lua"))
})

Router.all("/DevLoader", async (Request, Respond) => {
    const Method                        = Request.method
    const Headers                       = Request.headers
    const Executor                      = Headers["krampus-user-identifier"]

	if (!Method) return Respond.json({ ["Code"]: "MC-01" })
    if (!Headers) return Respond.json({ ["Code"]: "HC-01" })

	if (Method != "GET") return Respond.json({ ["Code"]: "MC-02" })
    if (!Executor) return Respond.json({ ["Code"]: "HC-02" })

	Respond.sendFile(Path.join(__dirname, "../", "../", "../", "Main", "Loaders", "Handler", "Developer Loader.lua"))
})

module.exports 							= Router