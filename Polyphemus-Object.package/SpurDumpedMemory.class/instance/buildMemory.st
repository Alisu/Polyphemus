building the memory
buildMemory

	"A VMMaker memory manager filled from the raw heap, in the seat SpurImageReader fills
	from an image file; nothing above has to know which it was."

	| manager |
	raw findHeap.
	interpreter := SimulatorSetUp newInterpreter.
	memory := interpreter objectMemory.
	interpreter imageName: self imageName.
	manager := MachineSimulatorMemoryManager new.
	memory memoryManager: manager.
	manager wordSize: memory wordSize.
	self loadMappingInto: manager.
	self setRegistersOf: memory.
	^ memory
