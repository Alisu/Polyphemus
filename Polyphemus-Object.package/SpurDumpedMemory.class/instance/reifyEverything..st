reifying
reifyEverything: aReifiedMemory

	"Walk every object into the reified view, so that the questions which enumerate -- which
	processes are there, what are this class's instances -- have something to enumerate.

	Both spaces. Old space is a straight walk from its start; new space has to be found by
	shape first, because a dump does not carry the allocation mark that says how much of eden
	is in use. Leaving it out is what kept the *running process* out of every answer: it
	lives in new space, as the newest objects do."

	self memory allOldSpaceObjectsDo: [ :oop | aReifiedMemory reifyOop: oop ].
	self youngObjectsDo: [ :oop | aReifiedMemory reifyOop: oop ].
	aReifiedMemory createCompressedVersion.
	^ aReifiedMemory
