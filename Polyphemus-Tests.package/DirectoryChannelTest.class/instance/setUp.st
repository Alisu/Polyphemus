running
setUp

	super setUp.
	directory := FileLocator temp / ('polyphemus-channel-' , self class name).
	directory ensureDeleteAll.
	channel := DirectoryChannel on: directory.
	agent := [ Smalltalk compiler evaluate: (PolyphemusAgent sourceServing: directory) ]
		         forkAt: Processor activePriority - 10
