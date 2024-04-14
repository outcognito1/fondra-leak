const Globe                           								= require("glob")
const Path 															= require("path")
const Config 														= require("../Config.json")

const DeleteCached 													= async function(File) {
	const FilePath 													= Path.resolve(File)

	if (require.cache[FilePath]) {
		delete require.cache[FilePath]
	}
}

const LoadFiles 													= async function(Directory) {
	try {
		const Files 												= await Globe.glob(Path.join(process.cwd(), Directory, "**/*.js").replace(/\\/g, "/"))
		const JSFiles 												= Files.filter(File => Path.extname(File) == ".js")

		await Promise.all(JSFiles.map(DeleteCached))

		return JSFiles
	} catch (Error) {
		console.log(Error)

		throw Error
	}
}

module.exports														= LoadFiles