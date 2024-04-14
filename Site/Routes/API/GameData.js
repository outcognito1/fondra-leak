const Express                           = require("express")
const FileSystem                        = require("fs")
const Path                              = require("path")
const Axios                        		= require("axios")

const Linker                            = require(Path.join(__dirname, "../", "../", "../", "Main", "Data", "Linker"))
const Database                         	= require(Path.join(__dirname, "../", "../", "../", "Main", "Schemas", "Data"))
const Config                         	= require(Path.join(__dirname, "../", "../", "../", "Config"))

const Router 							= Express.Router()

Router.use((Request, Respond, Next) => {
	Next()
})

Router.all("/GameData/:ID/:Type/:Key", async (Request, Respond) => {
    const Method                        = Request.method
    const Headers                       = Request.headers
    const Params                        = Request.params
    const Executor                      = Headers["krampus-user-identifier"]

    Params.Type                         = Params.Type.toLowerCase().charAt(0).toUpperCase() + Params.Type.toLowerCase().slice(1)

    if (!Method) return Respond.json({ ["Code"]: "MC-01" })
    if (Method != "GET") return Respond.json({ ["Code"]: "MC-02" })

    if (!Headers) return Respond.json({ ["Code"]: "HC-01" })
    if (!Executor) return Respond.json({ ["Code"]: "HC-02" })

    if (!Params) return Respond.json({ ["Code"]: "PC-01" })
    if (!Params.ID) return Respond.json({ ["Code"]: "PC-02" })
    if (!Params.Key) return Respond.json({ ["Code"]: "PC-03" })
    if (!Params.Type) return Respond.json({ ["Code"]: "PC-04" })

    if (!/^[a-zA-Z0-9]+$/.test(Params.ID)) return Respond.json({ ["Code"]: "SC-01" })
    if (!/^[a-zA-Z0-9]+$/.test(Params.Key)) return Respond.json({ ["Code"]: "SC-02" })
    if (!/^[a-zA-Z0-9]+$/.test(Params.Type)) return Respond.json({ ["Code"]: "SC-03" })
    if (!/^[a-zA-Z0-9]+$/.test(Executor)) return Respond.json({ ["Code"]: "SC-04" })

    let Data 						    = await Database.findById(Params.Key).catch(function(Error) {})
    let Time 							= Date.now() / 1000

    if (!Data) return Respond.json({ ["Code"]: "ID-00" })

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

    Data.Access                         = Refresh.data.access_token
    Data.Refresh                        = Refresh.data.refresh_token

    if (!Data.HWID) {
        Data.HWID                       = Executor
    }

    if (Data.HWID !== Executor) {
        Data.Blacklisted                = true
    }

    let Others                          = await Database.find({ HWID: Executor });

    if (Others.length > 1) {
        Data.Blacklisted                = true

        Others.forEach(async (User) => {
            User.Blacklisted            = true
    
            await User.save()
        })
    }

    await Data.save()

    if (Data.Blacklisted) {}
    if (!Linker.hasOwnProperty(Params.ID)) { Params.ID = 0 }

    if (!Data.Versions.includes("Developers") && Params.Type == "Developers") return Respond.json({ ["Code"]: "IA-00" })
    if (!Data.Versions.includes("Insiders") && Params.Type == "Insiders") return Respond.json({ ["Code"]: "IA-00" })

	if (Time - Data.Key.Generated >= 18000 && Data.Key.Required) return Respond.json({ ["Code"]: "EK-00" })

    const GameID                        = Params.ID
    const GameName                      = Linker[GameID].Name
    const GameLast                      = Linker[GameID].Last

    const FilePath                      = Path.join(__dirname, "../", "../", "../", "Main", "Games", Params.Type, GameName)
    const FWPath                        = Path.join(__dirname, "../", "../", "../", "Main", "Frameworks")

    if (!FileSystem.existsSync(FilePath)) return Respond.json({ ["Code"]: "IP-00" })

    const TelemetryData                 = FileSystem.readFileSync(Path.join(FWPath, "Telemetry", Params.Type + ".lua"), "utf-8")
    const BlacklistedData               = FileSystem.readFileSync(Path.join(FWPath, "Blacklisted" + ".lua"), "utf-8")
    const VisualData                    = FileSystem.readFileSync(Path.join(FilePath, "Visual.lua"), "utf-8")
    const MainData                      = FileSystem.readFileSync(Path.join(FilePath, "Main.lua"), "utf-8")
    const UIData                        = FileSystem.readFileSync(Path.join(FilePath, "UI.lua"), "utf-8")

    return Respond.json(Data.Blacklisted && {
        ["Main"]: BlacklistedData,
        
        ["GameName"]: GameName,
        ["GameLast"]: Date.now()
    } || {
        ["Telemetry"]: TelemetryData,
        ["Visual"]: VisualData,
        ["Main"]: MainData,
        ["UI"]: UIData,

        ["GameName"]: GameName,
        ["GameLast"]: GameLast
    })
})

module.exports 							= Router