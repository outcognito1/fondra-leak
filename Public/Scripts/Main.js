Init 															    = false
Music 														        = null

Songs                                                               = [ "Watching", "Among", "Feeling", "Outside", "Dream", "Mirage", "Sick" ]
Phrases                                                             = ["Click To Enter", "Only The Best", "Free", "Inspired :3"]
Messages                                                            = [ "A completely FREE Utility", "Sometimes, free beats paid", "The best things in life are often free", "👑 Fondra On Top! 📉 Moonlight On Bottom!", "Femboys are hot :3", "Femboys radiate a unique kind of hotness with their femininity", "Hotties come in all forms, and femboys are a prime example" ]
Selected                                                            = "Audios/Song.mp3".replace("Song", Songs[Math.floor(Math.random() * Songs.length)])

if (Math.floor(Math.random() * 100) <= 1) {
    Selected                                                        = "Audios/Boolets.mp3"
}

function Entrance() {
    const Effect                                                    = new TextScramble(document.getElementById("Enterance"))
    let Counter                                                     = 0

    const NewPhrase                                                 = () => {
        let Selected                                                = Phrases[Counter]
        Counter                                                     = (Counter + 1) % Phrases.length

        Effect.SetText(Selected).then(() => setTimeout(NewPhrase, 1500))
    }

    NewPhrase()
}

function Start(Data, Manual) {
    if (Init) return

	Init 															= true
	document.getElementsByClassName("Setup")[0].style.visibility    = "hidden"
	document.getElementsByClassName("Main")[0].style.visibility 	= "visible"
    
    Listener 													    = new Rythm()
    Listener.AddRythm("Information", "box-shadow", 0, 15, { min: 0.5, max: 25 })
    Listener.AddRythm("GameCard", "box-shadow", 0, 15, { min: 0.5, max: 8 })

    Listener.AddRythm("Title", "text-shadow", 0, 15)
    Listener.AddRythm("Message", "text-shadow", 0, 15)
    Listener.AddRythm("Button", "text-shadow", 0, 15)
    Listener.AddRythm("Divider", "text-shadow", 5, 15)

    Listener.connectExternalAudioElement(Music)
    Listener.start()
	Music.play()

    MCooldown                                                       = false
    MIndex                                                          = 0
    MCount                                                          = 0
    MDirection                                                      = "Up"

    setInterval(() => {
        if (MCooldown) return

        Message                                                     = Messages[MIndex]

        if (MCount === Message.length) {
            MCooldown                                               = true
            MDirection                                              = "Down"

            setTimeout(() => {
                MCooldown                                           = false
                MCount                                              = 0
    
                return
            }, 2000)
        }

        if (MCount === -Message.length + 1) {
            document.getElementById("Message").textContent          = "‎ "

            MCooldown                                               = true
            MDirection                                              = "Up"

            setTimeout(() => {
                MCooldown                                           = false
                MIndex                                              += 1
                MCount                                              = 0
    
                if (MIndex == Messages.length) MIndex = 0
            }, 500)
        }

        if (MCooldown) return

        MCount                                                      = MDirection === "Up" ? MCount + 1 : MCount - 1
        document.getElementById("Message").textContent              = Message.slice(0, MCount)
    }, 100)
}

function Donate() {
    document.getElementsByClassName("Main")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("About")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("Games")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("Donate")[0].style.visibility   = "visible"
}

function Games() {
    document.getElementsByClassName("Main")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("About")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("Games")[0].style.visibility 	= "visible"
	document.getElementsByClassName("Donate")[0].style.visibility   = "hidden"
}

function About() {
    document.getElementsByClassName("Main")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("About")[0].style.visibility 	= "visible"
	document.getElementsByClassName("Games")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("Donate")[0].style.visibility   = "hidden"
}

function Home() {
    document.getElementsByClassName("Main")[0].style.visibility 	= "visible"
	document.getElementsByClassName("About")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("Games")[0].style.visibility 	= "hidden"
	document.getElementsByClassName("Donate")[0].style.visibility   = "hidden"
}

window.onload = function(){
    ParticleJS.load("Particles", "Particles.json")
    Entrance()

    Music 														    = document.getElementById("Music")
    Music.volume 													= 0.085
    Music.src                                                       = Selected

    document.body.addEventListener("click", Start, true)
    document.getElementById("Donate-Button").addEventListener("click", Donate, true)
    document.getElementById("Games-Button").addEventListener("click", Games, true)
    document.getElementById("About-Button").addEventListener("click", About, true)
    document.getElementById("Home-Button-1").addEventListener("click", Home, true)
    document.getElementById("Home-Button-2").addEventListener("click", Home, true)
    document.getElementById("Home-Button-3").addEventListener("click", Home, true)
}