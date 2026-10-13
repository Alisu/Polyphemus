reading
commandsIn: someBytes do: aBlock

	"Each load command of a header at the start of someBytes: its type and where it starts."

	| at |
	at := 32.
	(self unsignedIn: someBytes at: 16 size: 4) timesRepeat: [
		at + 8 <= someBytes size ifFalse: [ ^ self ].
		aBlock value: (self unsignedIn: someBytes at: at size: 4) value: at.
		at := at + (self unsignedIn: someBytes at: at + 4 size: 4) ]
