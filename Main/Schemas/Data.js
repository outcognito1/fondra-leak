const Mongoose							= require("mongoose")
const Schema							= new Mongoose.Schema({
	Refresh: String,
	Access: String,

	HWID: String,
	Key: { type: Object, default: { Stage: 0, Last: 0, Generated: null, Required: true } },

	Blacklisted: Boolean,
	Versions: { type: Array, default: ["Public"] },

	User: String,
	ID: String
}, {
	versionKey: false
})

module.exports 							= Mongoose.model("Data", Schema)