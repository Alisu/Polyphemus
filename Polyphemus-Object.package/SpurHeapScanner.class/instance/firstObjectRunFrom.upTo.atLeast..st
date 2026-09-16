finding a heap
firstObjectRunFrom: anAddress upTo: aLimit atLeast: aCount

	"Where a run of at least this many objects begins between these addresses, or nil.

	Old space is found by its first three objects; new space has no such landmark -- nothing
	is at a known place there -- so the only thing to go on is that objects walk and noise
	does not. Every eight-byte boundary is tried, but a candidate whose header is already
	implausible is rejected before any walking, which is almost all of them.

	The count is the caller's to choose. Five hundred is the bar for believing a region is a
	heap; eden holds whatever the image has allocated since the last scavenge, which can be
	far less, so asking for that many there would find nothing where there is something."

	| candidate |
	candidate := anAddress.
	[ candidate < aLimit ] whileTrue: [
		((self whyNotAnObjectAt: candidate) isNil and: [
			 (self walkFrom: candidate upTo: aLimit) objectCount >= aCount ]) ifTrue: [
			^ candidate ].
		candidate := candidate + 8 ].
	^ nil
