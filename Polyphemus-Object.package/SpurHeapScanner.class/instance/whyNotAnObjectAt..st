walking
whyNotAnObjectAt: anAddress

	"Why no object can begin here, or nil. A class index of zero is a free chunk, which the walk
	steps over, not a reason."

	| header size |
	header := self headerAt: anAddress.
	header ifNil: [ ^ #outsideTheRegion ].
	(self classIndexIn: header) > largestClassIndex ifTrue: [ ^ #classIndexTooLarge ].
	(#( 6 7 8 ) includes: (self formatIn: header)) ifTrue: [ ^ #unusedFormat ].
	size := self bytesOfObjectAt: anAddress.
	size ifNil: [ ^ #saturatedCountWithNoOverflowWord ].
	(space hasAddress: anAddress + size - 1) ifFalse: [ ^ #objectRunsPastTheRegion ].
	^ nil
