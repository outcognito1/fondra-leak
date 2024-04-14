const Discord 														= require("discord.js")
const LoadEvents 													= require("../../../Handlers/EventHandler")
const LoadCommands 													= require("../../../Handlers/CommandHandler")

module.exports 														= {
	Developer: true,
	Data: new Discord.SlashCommandBuilder()
	.setName("reload")
	.setDescription("Reloader.")
	.setDefaultMemberPermissions(Discord.PermissionFlagsBits.Administrator)
	.addSubcommand((Options) => Options
		.setName("events")
		.setDescription("Reload Events.")
	)
	.addSubcommand((Options) => Options
		.setName("commands")
		.setDescription("Reload Commands.")
	)
}