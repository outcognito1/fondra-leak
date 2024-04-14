const Discord 														= require("discord.js")
const LoadEvents 													= require("../../../Handlers/EventHandler")
const LoadCommands 													= require("../../../Handlers/CommandHandler")

module.exports 														= {
	SubCommand: "reload.events",

	/**
	 * 
	 * @param {Discord.ChatInputCommandInteraction} Interaction 
	 */

	Execute(Interaction, Client) {
		for (const [Key, Value] of Client.Events) {
			Client.removeListener(`${Key}`, Value, true)
		}

		LoadEvents(Client)

		return Interaction.reply({
			content: "Reloaded Events",
			ephemeral: true
		})
	}
}