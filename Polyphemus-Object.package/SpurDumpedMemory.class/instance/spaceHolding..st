frames
spaceHolding: anAddress

	"Whether the dump holds this address at all, which for a frame pointer means the memory
	the stack pages live in rather than the object heap."

	^ (space hasAddress: anAddress) ifTrue: [ anAddress ] ifFalse: [ nil ]
