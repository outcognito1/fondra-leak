const LoadCommands 													= require("../../Handlers/CommandHandler")
const LoadStatus 													= require("../../Handlers/Status")
const Config 														= require("../../Config.json")
const Discord 														= require("discord.js")

module.exports 														= {
	Name: "ready",
	Once: true,

	Execute(Client) {
		LoadCommands(Client)
		LoadStatus(Client)
	}
}