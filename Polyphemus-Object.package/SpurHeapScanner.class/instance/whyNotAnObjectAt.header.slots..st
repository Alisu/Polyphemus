walking
whyNotAnObjectAt: anAddress header: aHeader slots: aSlotCount

	"A class index of zero is a free chunk, which the walk steps over, not a reason. A segment
	bridge spans memory a dump need not hold: what must be there is the segment it leads to."

	| size |
	(self classIndexIn: aHeader) > largestClassIndex ifTrue: [ ^ #classIndexTooLarge ].
	(#( 6 7 8 ) includes: (self formatIn: aHeader)) ifTrue: [ ^ #unusedFormat ].
	aSlotCount ifNil: [ ^ #saturatedCountWithNoOverflowWord ].
	size := 8 + ((aSlotCount max: 1) * 8).
	(self isSegmentBridgeHeader: aHeader) ifTrue: [
		^ ((space hasAddress: anAddress + size - 1) or: [ space hasAddress: anAddress + size ])
			  ifTrue: [ nil ]
			  ifFalse: [ #bridgeToNowhere ] ].
	(space hasAddress: anAddress + size - 1) ifFalse: [ ^ #objectRunsPastTheRegion ].
	^ nil
