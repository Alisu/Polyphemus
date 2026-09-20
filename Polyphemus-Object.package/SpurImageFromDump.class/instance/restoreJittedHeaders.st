writing
restoreJittedHeaders

	"Cog keeps a jitted method's header in its CogMethod and leaves the CogMethod's address
	where the header was. Put each one back, as CogMethodZone>>freeMethod: does at snapshot,
	in old space and in new: a jitted method may be in either. Answers how many."

	| scanner oop restored |
	scanner := dumped raw scanner.
	restored := 0.
	oop := dumped raw heapStart.
	[ oop notNil and: [ oop < dumped raw liveEnd ] ] whileTrue: [
		(self restoreTheHeaderOf: oop) ifTrue: [ restored := restored + 1 ].
		oop := scanner objectAfter: oop ].
	dumped raw youngObjectsDo: [ :each |
		(self restoreTheHeaderOf: each) ifTrue: [ restored := restored + 1 ] ].
	^ restored
