tests
testAReadingTakingAnothersClassesOverReadsItsOwnStacks

	"A step's reading is a copy of the last one (sharingClassesOn:): what it keeps of its own, its
	processes and stacks among them, must read it, not the reading it was copied from."

	| other |
	reifiedMemory stacks.
	reifiedMemory processes.
	other := reifiedMemory sharingClassesOn: memory.
	self assert: (other stacks instVarNamed: 'memory') identicalTo: other.
	self assert: (other processes instVarNamed: 'memory') identicalTo: other
