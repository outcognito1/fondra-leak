const Data 															= require("../Schemas/Join")
const Config 														= require("../Config.json")

const LoadConfig 													= async function(Client) {
	(await Data.find()).forEach((Document) => {
		Client.GuildsData.set(Document.Guild, {
			Log: Document.Log,
			Bot: Document.Bot,
			Member: Document.Member
		})
	})

	return console.log("Loaded Guild Configs.")
}

module.exports														= LoadConfig