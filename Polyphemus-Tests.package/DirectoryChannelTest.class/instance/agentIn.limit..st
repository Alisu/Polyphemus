helpers
agentIn: aDirectory limit: aDurationOrNil

	"Another agent run here, on a bell of its own, ending by itself after that long without a
	request (never with nil); its channel. The test terminates it."

	| ringed |
	ringed := Semaphore new.
	agent := [
	         Smalltalk compiler
		         receiver: ringed;
		         evaluate: (PolyphemusAgent sourceServing: aDirectory bell: 'self' limit: aDurationOrNil) ]
		         forkAt: Processor activePriority - 10.
	^ (DirectoryChannel on: aDirectory)
		  ringing: [ ringed instVarAt: 3 put: 1 ];
		  yourself
