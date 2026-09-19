building the memory
buildMemory

	"A VMMaker memory manager filled from the raw heap, in the seat SpurImageReader fills
	from an image file; nothing above has to know which it was."

	| manager |
	raw findHeap.
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
