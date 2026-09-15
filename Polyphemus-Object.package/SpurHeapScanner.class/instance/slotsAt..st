reading headers
slotsAt: anAddress

	"How many slots the object here has, following the overflow word when the header says to.
	nil when that cannot be answered."

	| header stated before |
	header := self headerAt: anAddress.
	header ifNil: [ ^ nil ].
	stated := self slotCountIn: header.
	stated = 255 ifFalse: [ ^ stated ].

	before := self headerAt: anAddress - 8.
	before ifNil: [ ^ nil ].
	^ (self slotCountIn: before) = 255
		  ifTrue: [ before bitAnd: 16rFFFFFFFF ]
		  ifFalse: [ nil ]
