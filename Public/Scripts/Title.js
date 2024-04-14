function Title(Data, Manual) {
    if (Init) return
    if (Manual) return

    TCooldown                                                       = false
    TCount                                                          = 0
    TDirection                                                      = "Up"

    setInterval(() => {
        if (TCooldown) return

        Message                                                     = "Fondra <3"

        if (TCount === Message.length) {
            TCooldown                                               = true
            TDirection                                              = "Down"

            setTimeout(() => {
                TCooldown                                           = false
                TCount                                              = 0
    
                return
            }, 2000)
        }

        if (TCount === -Message.length + 1) {
            document.title                                          = "‎ "

            TCooldown                                               = true
            TDirection                                              = "Up"

            setTimeout(() => {
                TCooldown                                           = false
                TCount                                              = 0
            }, 500)
        }

        if (TCooldown) return

        TCount                                                      = TDirection === "Up" ? TCount + 1 : TCount - 1
        document.title                                              = Message.slice(0, TCount)
    }, 250)
}

Title()