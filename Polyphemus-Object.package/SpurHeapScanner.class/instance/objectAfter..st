walking
objectAfter: anAddress

	"Where the next object begins, or nil. When the word after this object is a saturated
	overflow word, the next object starts eight bytes further, as VMMaker's walk says."

	| size next after |
	size := self bytesOfObjectAt: anAddress.
	size ifNil: [ ^ nil ].
	next := anAddress + size.
	after := self headerAt: next.
	^ (after notNil and: [ (self slotCountIn: after) = 255 ])
		  ifTrue: [ next + 8 ]
		  ifFalse: [ next ]
