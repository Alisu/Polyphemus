reading
interpreterOnImageFile: aPath

	"An image file opened in VMMaker's simulator and not started, built as the simulator builds
	one -- no test class of VMMaker's, whose helpers each VMMaker version renames."

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
	^ interpreter
