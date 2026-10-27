tests
testAReadingTakingAnothersClassesOverReadsItsOwnStacks

	"A step's reading is a copy of the last one (sharingClassesOn:): its processes, stacks and
	compilations must read it, not the reading it was copied from."

	| other |
	reifiedMemory stacks.
	reifiedMemory processes.
	reifiedMemory compilations.
	other := reifiedMemory sharingClassesOn: memory.
	self assert: (other stacks instVarNamed: 'memory') identicalTo: other.
	self assert: (other processes instVarNamed: 'memory') identicalTo: other.
	self assert: (other compilations instVarNamed: 'memory') identicalTo: other
