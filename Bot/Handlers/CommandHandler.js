module.exports														= async function(Client) {	  
	console.time("Commands")

	const Load                           							= require("../Functions/FileLoader")
	const Commands 													= new Array()
	const Files 													= await Load("Commands")

	await Client.Commands.clear()
	await Client.SubCommands.clear()

	let CommandsArray 												= []
	
	for (const File of Files) {
	  	try {
			const Command 											= require(File)

			if (Command.SubCommand) {
				Client.SubCommands.set(Command.SubCommand, Command)
				continue
			}

			Client.Commands.set(Command.Data.name, Command)
			CommandsArray.push(Command.Data.toJSON())
			Commands.push({ Commands: Command.Data.name, Status: "✅" });
	  	} catch (Error) {
			console.log(Error)
			Commands.push({ Commands: File.split("/").pop().slice(0, -3), Status: "🔴" });
	  	}
	}

	await Client.application.commands.set(CommandsArray)
	
	console.log("\n")
	console.table(Commands, ["Commands", "Status"])
	console.info("\n\x1b[36m%s\x1b[0m", "Commands Loaded.")
	console.timeEnd("Commands")
}