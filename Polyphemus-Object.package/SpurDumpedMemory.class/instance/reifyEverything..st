reifying
reifyEverything: aReifiedMemory

	"Walk every object of old space into the reified view, so that the questions which
	enumerate -- which processes are there, what are this class's instances -- have
	something to enumerate. Around twenty seconds for the million objects of a real image.

	New space is not walked, so young objects are absent from the result. See
	`#setUpNewSpaceOf:`."

	self memory allOldSpaceObjectsDo: [ :oop | aReifiedMemory reifyOop: oop ].
	aReifiedMemory createCompressedVersion.
	^ aReifiedMemory
