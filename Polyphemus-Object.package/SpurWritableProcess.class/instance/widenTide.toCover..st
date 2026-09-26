signalling
widenTide: aLetter toCover: aSlot

	"The VM signals only the slots between a tide's low and high marks."

	| low high |
	low := self variables addressOf: 'lowTide' , aLetter.
	high := self variables addressOf: 'highTide' , aLetter.
	(self int32At: low) > aSlot ifTrue: [ self int32At: low put: aSlot ].
	(self int32At: high) < aSlot ifTrue: [ self int32At: high put: aSlot ]
