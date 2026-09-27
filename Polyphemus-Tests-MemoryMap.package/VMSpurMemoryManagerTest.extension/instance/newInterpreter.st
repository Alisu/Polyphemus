*Polyphemus-Tests-MemoryMap
newInterpreter

	"Removed in VMMaker v10.0.4, where setUp builds the whole environment: our fixtures open an
	image in the simulator instead, so they need only an interpreter on an empty memory -- made
	as Polyphemus makes one, which holds across VMMaker versions."

	interpreter := Polyphemus newSimulatorInterpreter.
	memory := interpreter objectMemory.
	^ interpreter
