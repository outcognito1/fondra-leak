const Discord 														= require("discord.js")
const Transcripts 													= require("discord-html-transcripts")

module.exports 														= {
	Data: new Discord.SlashCommandBuilder()
	.setName("clear")
	.setDescription("Bulk delete messages.")
	.setDefaultMemberPermissions(Discord.PermissionFlagsBits.ManageMessages)
	.setDMPermission(false)
	.addNumberOption((Options) => Options
		.setName("amount")
		.setDescription("The amount of messages to delete.")
		.setMinValue(1)
		.setMaxValue(100)
		.setRequired(true)
	)
	.addStringOption((Options) => Options
		.setName("reason")
		.setDescription("The reason for purging messages.")
		.setRequired(true)
	)
	.addUserOption((Options) => Options
		.setName("target")
		.setDescription("Only deletes the message for provided user.")
		.setRequired(false)
	),

	/**
	 * 
	 * @param {Discord.ChatInputCommandInteraction} Interaction 
	 */

	async Execute(Interaction, Client) {
		const Amount 												= Interaction.options.getNumber("amount")
		const Reason 												= Interaction.options.getString("reason")
		const Target 												= Interaction.options.getMember("target")

		const Channel 												= await Interaction.channel.messages.fetch()
		const Log 													= Interaction.guild.channels.cache.get("1150487360694399036")

		const ResponseEmbed											= new Discord.EmbedBuilder().setColor("Green")
		const LogEmbed												= new Discord.EmbedBuilder().setColor("#d4d4d4").setAuthor({name: "CLEAR COMMAND USED"})

		if (Target) {
			let Index 												= 0
            let Messages 											= []

            Channel.filter((Message) => {
                if(Message.author.id === Target.id && Amount > Index) {
                    Messages.push(Message)
                    Index++
                }
            })

            const Transcript 										= await Transcripts.generateFromMessages(Messages, Interaction.channel)

            Interaction.channel.bulkDelete(Messages, true).then((Data) => {
                Interaction.reply({
                    embeds: [ResponseEmbed.setDescription(`🧹 Cleared \`${Data.size}\` messages from ${Target}`)],
                    ephemeral: true
                })
                
				Log.send({
                    embeds: [LogEmbed.setDescription([
						`• Moderator: ${Interaction.member}`,
						`• Target: ${Target || "none"}`,
						`• Channel: ${Interaction.channel}`,
						`• Reason: ${Reason}`,
						`• Total: ${Data.size}`
					].join("\n"))],
                    files: [Transcript]
                })
            })
		} else {
			const Transcript 										= await Transcripts.createTranscript(Interaction.channel, { limit: Amount })

            Interaction.channel.bulkDelete(Amount, true).then((Data) => {
                Interaction.reply({
                    embeds: [ResponseEmbed.setDescription(`🧹 Cleared \`${Data.size}\` messages`)],
                    ephemeral: true
                })
                
				Log.send({
                    embeds: [LogEmbed.setDescription([
						`• Moderator: ${Interaction.member}`,
						`• Target: ${Target || "none"}`,
						`• Channel: ${Interaction.channel}`,
						`• Reason: ${Reason}`,
						`• Total: ${Data.size}`
					].join("\n"))],
                    files: [Transcript]
                })
            })
		}
	}
}