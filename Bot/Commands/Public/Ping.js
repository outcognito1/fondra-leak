const Discord 														= require("discord.js")

module.exports 														= {
	Developer: true,
	Data: new Discord.SlashCommandBuilder()
	.setName("ping")
	.setDescription("Debug Command."),

	/**
	 * 
	 * @param {Discord.ChatInputCommandInteraction} Interaction 
	 */

	Execute(Interaction, Client) {
		return Interaction.reply({
			content: "Pong!",
			ephemeral: true
		})
	}
}