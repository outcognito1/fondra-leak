const Config 														= require("../Config.json")
const Discord 														= require("discord.js")

const GetData 														= async function() {
	return Config.Status
}

const LoadStatus 													= async function(Client) {
	let Info														= await GetData()
	let Data 														= Info[Math.floor(Math.random() * Info.length)]

	Client.user.setActivity(Data.Message, { type: Discord.ActivityType[Data.Type] })

	setInterval(function () {
		Data 														= Info[Math.floor(Math.random() * Info.length)]

		Client.user.setActivity(Data.Message, { type: Discord.ActivityType[Data.Type] })
	}, 10 * 1000)
}

module.exports														= LoadStatus