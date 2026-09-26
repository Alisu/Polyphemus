running
setUp

	"The agent runs here, its bell a semaphore of the test's that the channel rings."

	super setUp.
	directory := PolyphemusEdition current scratch / ('polyphemus-channel-' , self class name).
	directory ensureDeleteAll.
	bell := Semaphore new.
	channel := (DirectoryChannel on: directory)
		           ringing: [ bell instVarAt: 3 put: 1 ];
		           yourself.
	agent := [
	         Smalltalk compiler
		         receiver: bell;
		         evaluate: (PolyphemusAgent sourceServing: directory bell: 'self') ]
		         forkAt: Processor activePriority - 10
