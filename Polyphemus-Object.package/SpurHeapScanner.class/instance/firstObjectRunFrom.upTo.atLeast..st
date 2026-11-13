finding a heap
firstObjectRunFrom: anAddress upTo: aLimit atLeast: aCount

	"Where a run of at least aCount live objects starts between the two addresses, or nil. What a
	walk that fell short counted from each object is kept, so each word is stepped from once (#182)."

	| known candidate |
	known := Dictionary new.
	candidate := anAddress.
	[ candidate < aLimit ] whileTrue: [
		(self liveObjectsFrom: candidate upTo: aLimit atLeast: aCount known: known) >= aCount ifTrue: [
			^ candidate ].
		candidate := candidate + 8 ].
	^ nil