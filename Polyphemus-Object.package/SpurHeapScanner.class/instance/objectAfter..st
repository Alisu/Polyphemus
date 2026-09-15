walking
objectAfter: anAddress

	"Where the next object begins, or nil.

	An object with too many slots is preceded by a word whose slot count byte is saturated. So
	when the word after this object reads as saturated, it is that overflow word and the next
	object begins eight bytes further on. VMMaker's own walk says exactly this."

	| size next after |
	size := self bytesOfObjectAt: anAddress.
	size ifNil: [ ^ nil ].
	next := anAddress + size.
	after := self headerAt: next.
	^ (after notNil and: [ (self slotCountIn: after) = 255 ])
		  ifTrue: [ next + 8 ]
		  ifFalse: [ next ]
