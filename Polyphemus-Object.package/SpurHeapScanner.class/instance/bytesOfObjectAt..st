reading headers
bytesOfObjectAt: anAddress

	"Header plus slots. Every object is at least one slot wide, because a forwarding pointer
	has to fit in it."

	| slots |
	slots := self slotsAt: anAddress.
	slots ifNil: [ ^ nil ].
	^ 8 + ((slots max: 1) * 8)
