const Discord 														= require("discord.js")
const Database 														= require("../../Schemas/Infractions")
const MS 															= require("ms")

module.exports 														= {
	Data: new Discord.SlashCommandBuilder()
	.setName("timeout")
	.setDescription("Communication Rescriction.")
	.setDefaultMemberPermissions(Discord.PermissionFlagsBits.ModerateMembers)
	.setDMPermission(false)
	.addUserOption((Options) => Options
		.setName("target")
		.setDescription("The target to timeout.")
		.setRequired(true)
	)
	.addStringOption((Options) => Options
		.setName("duration")
		.setDescription("The timeout duration. [1m, 1h, 1d]")
		.setRequired(true)
	)
	.addStringOption((Options) => Options
		.setName("reason")
		.setDescription("The reason for timeout.")
		.setMaxLength(512)
		.setRequired(false)
	),

	/**
	 * 
	 * @param {Discord.ChatInputCommandInteraction} Interaction 
	 */

	async Execute(Interaction, Client) {
		const Target 												= Interaction.options.getMember("target") || "Unknown."
		const Duration 												= Interaction.options.getString("duration") || "Unknown."
		const Reason 												= Interaction.options.getString("reason") || "Unknown."

		const Errors												= []
		const Failed												= new Discord.EmbedBuilder()
		.setAuthor({ name: "Could not timeout member due to" })
		.setColor("Red")

		if (Target == "Unknown.") return Interaction.reply({
			embeds: [Failed.setDescription("This person does not exist.")],
			ephemeral: true
		})

		if (!MS(Duration))
		Errors.push("Duration provided is invalid.")

		if (MS(Duration) && MS(Duration) > MS("28d"))
		Errors.push("Duration provided is over the 28 day limit.")

		if (!Target.manageable || !Target.moderatable)
		Errors.push("Selected target is not moderateable.")

		if (Interaction.member.roles.highest.position < Target.roles.highest.position)
		Errors.push("Selected target is a higher role than you.")

		if (Errors.length) return Interaction.reply({
			embeds: [Failed.setDescription(Errors.join("\n"))],
			ephemeral: true
		})

		Target.timeout(MS(Duration), Reason).catch((Error) => {
			Interaction.reply({
				embeds: [Failed.setDescription("An uncommon error.")]
			})

			return console.log(Error)
		})

		const NewInfraction											= {
			IssuerID: Interaction.member.id,
			IssuerTag: Interaction.member.user.tag,
			Reason: Reason,
			Date: Date.now()
		}

		let Data 													= await Database.findOneAndUpdate({ 
			Guild: Interaction.guild.id, 
			User: Target.id 
		}, {
			$push: {
				Infractions: NewInfraction
			}
		}, {
			upsert: true,
			new: true
		})

		const Success												= new Discord.EmbedBuilder()
		.setAuthor({ name: "Timeout issues", iconURL: Interaction.guild.iconURL() })
		.setColor("#d4d4d4")
		.setDescription([
			`${Target} was issused a timeout for **${MS(MS(Duration), {long: true})}** by ${Interaction.member}`,
			`bringing their infractions total to **${Data.Infractions.length} points**`,
			`\nReason: ${Reason}`
		].join("\n"))

		Interaction.reply({
			embeds: [Success]
		})
	}
}