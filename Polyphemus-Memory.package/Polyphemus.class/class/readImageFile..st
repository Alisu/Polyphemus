reading
readImageFile: aPath

	"An image file opened in the simulator and not started: started, its running process would
	be married to a frame and read one frame deep. Refused below #readabilityOfImageFile:'s rungs."

	| memory interpreter readability |
	readability := self readabilityOfImageFile: aPath.
	#( #bytes #heap #objects #classes ) do: [ :each | readability require: each ].
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
