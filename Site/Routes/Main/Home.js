const Express                           = require("express")
const FileSystem                        = require("fs")
const Path                              = require("path")
const Router 							= Express.Router()

Router.use((Request, Respond, Next) => {
	Next()
})

Router.get("/", (Request, Respond) => {
	Respond.sendFile(Path.join(__dirname, "../", "../", "Pages", "Main.html"))
})

Router.get("/Discord", (Request, Respond) => {
	Respond.redirect("https://discord.gg/fondra")
})

Router.get("/Features", (Request, Respond) => {
	Respond.redirect("https://github.com/Fondra-Hub/Features/tree/main")
})

module.exports 							= Router