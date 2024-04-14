const { Client, GatewayIntentBits, Partials, Collection } 			= require("discord.js")
const { Guilds, GuildMembers, GuildMessages }						= GatewayIntentBits
const { User, Message, GuildMember, ThreadMember }					= Partials

const Bot 															= new Client({ 
	intents: [ Guilds, GuildMembers, GuildMessages ],
	partials: [ User, Message, GuildMember, ThreadMember ]
})

const LoadEvents 													= require("./Handlers/EventHandler")
const LoadGuilds 													= require("./Functions/ConfigLoader")
const Mongoose														= require("mongoose")

Bot.Config															= require("./Config.json")
Bot.Events 															= new Collection()
Bot.Commands 														= new Collection()
Bot.SubCommands 													= new Collection()
Bot.GuildsData 														= new Collection()

Mongoose.connect(Bot.Config.Database, {}).then(() => console.log("Client Connected to Database."))

LoadEvents(Bot)
LoadGuilds(Bot)

Bot.login(Bot.Config.Token)