accessing
boundsOf: aName

	"A space of new space as the VM keeps one: its start, then its limit."

	^ (self at: aName) -> (memory unsignedAt: (self addressOf: aName) + 8 size: 8)
