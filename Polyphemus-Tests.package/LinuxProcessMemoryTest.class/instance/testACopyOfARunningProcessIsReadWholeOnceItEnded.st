tests
testACopyOfARunningProcessIsReadWholeOnceItEnded

	"#85: what a reading needs of a running VM, copied while it is held still. Read once the VM
	has ended: nothing comes from a later moment, since there is none, and nothing is missing."

	| pid copy dumped |
	pid := self launchObservableTarget.
	[ copy := Polyphemus copyProcess: pid ] ensure: [ LibC system: 'kill -9 ' , pid printString ].
	(1 to: 50) detect: [ :each |
		('/proc/' , pid printString) asFileReference exists not or: [
			(Delay forMilliseconds: 100) wait.
			false ] ] ifNone: [ nil ].

	dumped := SpurDumpedMemory on: copy.
	self assert: (dumped reifyEverything: dumped reifiedMemory) allReifiedProcesses notEmpty
