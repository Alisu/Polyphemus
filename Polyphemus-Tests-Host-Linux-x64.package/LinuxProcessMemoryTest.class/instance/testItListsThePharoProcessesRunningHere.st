tests
testItListsThePharoProcessesRunningHere

	"Someone has to choose a process id from somewhere. This one is running, so the list is
	never empty, and it carries the command line so the choice can be made on something
	more than a number."

	| found |
	found := LinuxProcessMemory pharoProcesses.

	self assert: found notEmpty.
	self assert: (found allSatisfy: [ :each | each key isInteger ]).
	self assert: (found anySatisfy: [ :each |
			 each value asLowercase includesSubstring: 'pharo' ])
