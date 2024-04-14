const Express                           = require("express")
const FileSystem                        = require("fs")
const Path                              = require("path")
const Router 							= Express.Router()

Router.use((Request, Respond, Next) => {
	Next()
})

Router.get("/", (Request, Respond) => {
  	Respond.sendFile(Path.join(__dirname, "../", "../", "Pages", "Games.html"))
})

module.exports 							= Router