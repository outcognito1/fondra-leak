class TextScramble {
    constructor(Object) {
        this.Element 												= Object
        this.Characters 											= '?!#$%^[]__-'
        this.Update 												= this.Update.bind(this)
    }

    SetText(Text) {
		const New 													= Text
        const Old 													= this.Element.innerText
        const Result 												= new Promise(Resolve => this.Resolve = Resolve)
        const length												= Math.max(Old.length, New.length)

		this.Frame 													= 0
        this.Queue 													= Array.from({ length }, (_, i) => ({
            From: Old[i] || "",
            To: New[i] || "",

            Start: Math.floor(Math.random() * 40),
            End: 0,
        }))

        this.Queue.forEach((Item, _) => {
            Item.End 												= Item.Start + Math.floor(Math.random() * 40)

            if (!Item.Character || Math.random() < 0.28) { Item.Character = this.Characters[Math.floor(Math.random() * this.Characters.length)] }
        })

        cancelAnimationFrame(this.FrameRequest)

        this.Update()

        return Result
    }

    Update() {
        let Output 													= ""
        let Complete 												= 0

        for (let i = 0, n = this.Queue.length; i < n; i++) {
            const { From, To, Start, End, Character } 				= this.Queue[i]

            if (this.Frame >= End) {
                Complete++
                Output += To
            } else if (this.Frame >= Start) {
                Output += `<span class="Glitch">${Character}</span>`
            } else {
                Output += From
            }
        }

        this.Element.innerHTML 										= Output

        if (Complete === this.Queue.length) {
            this.Resolve()
        } else {
            this.FrameRequest = requestAnimationFrame(() => this.Update())
            this.Frame++
        }
    }
}