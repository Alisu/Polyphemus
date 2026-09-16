holding it still
stop

	"Hold the process still, so that what we read of it was true all at once.

	A running process is a moving target: the garbage collector may be half way through, an
	allocation may be half done, and a heap read across those never existed at any instant.
	The free lists and a walk over the objects disagreeing is exactly how that shows up.

	This needs no permission beyond being allowed to signal the process, which the same user
	always is -- unlike reading it. And it is the honest thing to do before reading anything
	that is still going."

	LibC system: 'kill -STOP ' , pid asString.
	^ self waitForState: $T
