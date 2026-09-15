walking
whyNotAnObjectAt: anAddress

	"The same checks, saying which one failed. A walk that stops is more useful when it says
	what stopped it."

	| header size |
	header := self headerAt: anAddress.
	header ifNil: [ ^ #outsideTheRegion ].
	(self classIndexIn: header) = 0 ifTrue: [ ^ #classIndexOfZero ].
	(self classIndexIn: header) > largestClassIndex ifTrue: [ ^ #classIndexTooLarge ].
	(#( 6 7 8 ) includes: (self formatIn: header)) ifTrue: [ ^ #unusedFormat ].
	size := self bytesOfObjectAt: anAddress.
	size ifNil: [ ^ #saturatedCountWithNoOverflowWord ].
	(space hasAddress: anAddress + size - 1) ifFalse: [ ^ #objectRunsPastTheRegion ].
	^ nil
