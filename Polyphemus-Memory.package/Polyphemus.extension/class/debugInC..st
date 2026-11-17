*Polyphemus-Memory
debugInC: aPid

	"The real Pharo debugger on the process its VM ran when it entered C, its title saying which
	call (#18); refused before anything is read, saying where the VM is, when it is not in C."

	^ StDebugger openOn: (ReifiedDebugSession onTheProcessThatEnteredC: aPid) withFullView: true