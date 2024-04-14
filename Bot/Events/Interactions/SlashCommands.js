const Discord 														= require("discord.js")
const Config 														= require("../../Config.json")

module.exports 														= {
	Name: "interactionCreate",
	Once: true,

	/**
	 * 
	 * @param {Discord.ChatInputCommandInteraction} Interaction 
	 */

	Execute(Interaction, Client) {
		if (!Interaction.isChatInputCommand()) return

		const Command 												= Client.Commands.get(Interaction.commandName)

		if (!Command) return Interaction.reply({
			content: "This command is outdated.",
			ephemeral: true
		})
		
		if (Command.Developer && Interaction.user.id !== Config.DeveloperID) return Interaction.reply({
			content: `This command is only available to incognito.`,
			ephemeral: true
		})

		const SubCommand											= Interaction.options.getSubcommand(false)
		
		if (SubCommand) {
			const SubCommandFile 									= Client.SubCommands.get(`${Interaction.commandName}.${SubCommand}`)

			if (!SubCommandFile) return Interaction.reply({
				content: "This subcommand is outdated.",
				ephemeral: true
			})

			SubCommandFile.Execute(Interaction, Client)
		} else {
			Command.Execute(Interaction, Client)
		}
	}	
}