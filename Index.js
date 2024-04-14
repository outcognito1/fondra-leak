const Mongoose                          = require("mongoose")
const Express                           = require("express")
const Path                              = require("path")
const App                               = Express()

const WS 								= require("express-ws")(App)
const BodyParser                        = require("body-parser")
const CookieParser                      = require("cookie-parser")

const Information                       = require(Path.join(__dirname, "Site", "Routes", "API", "Information"))
const Telemetry                         = require(Path.join(__dirname, "Site", "Routes", "API", "Telemetry"))
const GameData                          = require(Path.join(__dirname, "Site", "Routes", "API", "GameData"))
const AuthO2                            = require(Path.join(__dirname, "Site", "Routes", "API", "AuthO2"))
const Key                               = require(Path.join(__dirname, "Site", "Routes", "API", "Key"))
const Home                              = require(Path.join(__dirname, "Site", "Routes", "Main", "Home"))
const Error                             = require(Path.join(__dirname, "Site", "Routes", "Main", "Error"))
const Config                            = require(Path.join(__dirname, "Config"))

Mongoose.connect(Config.Mongo, {}).then(() => console.log("Client Connected to Database."))

App.use(Express.static(Path.join("Public")))
App.use(BodyParser.json())
App.use(CookieParser())

App.set("view engine", "ejs")
App.set("json spaces", 2)
App.disable("x-powered-by")

App.use("/API", Information)
App.use("/API", Telemetry)
App.use("/API", GameData)
App.use("/API", AuthO2)
App.use("/API", Key)
App.use("/", Home)
App.use("*", Error)

App.listen(8080, () => {
    console.log("Running on 8080 Port.")
})