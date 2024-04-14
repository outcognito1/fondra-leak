module.exports														= async function(Client) {
	console.time("Events")

	const Load                           							= require("../Functions/FileLoader")
	const Events 													= new Array()
	const Files 													= await Load("Events")

	for (const File of Files) {
		try {
			const Event 											= require(File)
			const Execute											= (...Args) => Event.Execute(...Args, Client)
			const Target 											= Event.rest ? Client.rest : Client

			Target[Event.once ? "once" : "on"](Event.Name, Execute)
			Client.Events.set(Event.Name, Execute)

			Events.push({ Event: Event.Name, Status: "✅" })
		} catch(Error) {
			Events.push({ Event: File.split("/").pop().slice(0, -3), Status: "🔴" })
		}
	}

	console.table(Events, ["Event", "Status"])
	console.info("\n\x1b[36m%s\x1b[0m", "Events Loaded.")
	console.timeEnd("Events")
	console.log("\n")
}
