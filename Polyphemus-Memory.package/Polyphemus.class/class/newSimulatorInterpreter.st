reading
newSimulatorInterpreter

	"VMMaker's interpreter simulator on a fresh 64-bit Spur memory, nothing loaded, built as the
	simulator builds itself -- no test class of VMMaker's, whose helpers each version renames."

	| memory |
	memory := Spur64BitMemoryManager simulatorClass new.
	StackInterpreterSimulatorLSB
		initializeWithOptions: {
				#BytesPerWord.
				8.
				#ObjectMemory.
				memory class name }
		objectMemoryClass: memory class.
	^ StackInterpreterSimulatorLSB basicNew
		  objectMemory: memory;
		  basicInitialize;
		  pluginList: {  };
		  yourself
