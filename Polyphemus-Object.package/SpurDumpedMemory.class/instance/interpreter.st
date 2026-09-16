accessing
interpreter

	"The simulated interpreter this memory was built into.

	`MemoryInspector` and the other presenters open on an interpreter rather than on a
	reified memory, so a dump can be given to them the same way an image file is."

	^ interpreter ifNil: [ self memory. interpreter ]
