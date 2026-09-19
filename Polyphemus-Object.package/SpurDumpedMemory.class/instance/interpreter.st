accessing
interpreter

	"The simulated interpreter the memory was built into; MemoryInspector opens on it."

	^ interpreter ifNil: [ self memory. interpreter ]
