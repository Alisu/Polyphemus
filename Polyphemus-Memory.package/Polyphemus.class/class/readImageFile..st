reading
readImageFile: aPath

	"An image file, read as the snapshot it is: opened in the simulator and *not started*.
	Starting it would let the virtual machine marry the running process to a frame, and that
	process's stack would then read one frame deep instead of its real depth."

	| memory interpreter |
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
	interpreter openOn: aPath asFileReference fullName.
	interpreter initStackPages.
	^ FullyReifiedMemory on: memory
