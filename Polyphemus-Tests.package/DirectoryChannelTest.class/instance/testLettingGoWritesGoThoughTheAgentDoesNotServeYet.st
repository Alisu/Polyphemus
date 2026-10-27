tests
testLettingGoWritesGoThoughTheAgentDoesNotServeYet

	"The one letting go is told the agent was not there; an agent that serves later finds go and
	ends, rung or not."

	| silent late |
	(directory / 'silent') ensureCreateDirectory.
	silent := DirectoryChannel on: directory / 'silent'.
	self deny: (silent letGoWithin: 100 milliSeconds).
	self assert: (directory / 'silent' / 'go') exists.
	late := [
	        Smalltalk compiler
		        receiver: Semaphore new;
		        evaluate: (PolyphemusAgent sourceServing: directory / 'silent' bell: 'self') ]
		        forkAt: Processor activePriority - 10.
	[ self assert: (self waitFor: [ late isTerminated ]) ] ensure: [ late terminate ]
