finding a heap
firstObjectRunFrom: anAddress upTo: aLimit atLeast: aCount

	"Where a run of at least aCount objects starts between the two addresses, or nil.
	Implausible headers are rejected before walking."

	| candidate |
	candidate := anAddress.
	[ candidate < aLimit ] whileTrue: [
		((self whyNotAnObjectAt: candidate) isNil and: [
			 (self walkFrom: candidate upTo: aLimit) objectCount >= aCount ]) ifTrue: [
			^ candidate ].
		candidate := candidate + 8 ].
	^ nil
