building the memory
buildMemory

	"The same seat `SpurImageReader` sits in. `StackInterpreterSimulator>>openOn:` makes a
	memory manager, gives it to the object memory and has a reader fill it; this fills it
	from a dump instead, and nothing above has to know which it was."

	| manager |
	self findHeap.
	memory := Spur64BitMemoryManager simulatorClass new.
	StackInterpreterSimulatorLSB
		initializeWithOptions: {
				#BytesPerWord.
				8.
				#ObjectMemory.
				memory class name }
		objectMemoryClass: memory class.
	interpreter := StackInterpreterSimulatorLSB basicNew
		               objectMemory: memory;
		               basicInitialize;
		               pluginList: {  };
		               yourself.
	interpreter imageName: self imageName.
	manager := MachineSimulatorMemoryManager new.
	memory memoryManager: manager.
	manager wordSize: memory wordSize.
	self loadMappingInto: manager.
	self setRegistersOf: memory.
	^ memory
