const Express                           = require("express")
const FileSystem                        = require("fs")
const Path                              = require("path")
const Router 							= Express.Router()

Router.use((Request, Respond, Next) => {
	Next()
})

Router.get("/", (Request, Respond) => {
	Respond.status(404)
  	Respond.end("Page Not Found")
})

module.exports 							= Router