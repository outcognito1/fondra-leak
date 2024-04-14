const Discord 														= require("discord.js")
const LoadEvents 													= require("../../../Handlers/EventHandler")
const LoadCommands 													= require("../../../Handlers/CommandHandler")

module.exports 														= {
	SubCommand: "reload.commands",

	/**
	 * 
	 * @param {Discord.ChatInputCommandInteraction} Interaction 
	 */

	Execute(Interaction, Client) {
		LoadCommands(Client)

		return Interaction.reply({
			content: "Reloaded Commands",
			ephemeral: true
		})
	}
}