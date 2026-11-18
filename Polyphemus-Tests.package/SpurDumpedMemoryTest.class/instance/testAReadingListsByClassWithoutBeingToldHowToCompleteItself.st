tests
testAReadingListsByClassWithoutBeingToldHowToCompleteItself

	"#211: a reading asked of its dumped memory, and not then told where to complete itself from,
	listed by class among what it had reified so far: no process at all, on a sound core, and
	nothing said. It lists by the walk over the heap from the start."

	| processes |
	processes := dumped reifiedMemory allReifiedProcesses.
	self assert: processes size > 1.
	self assert: processes size equals: self reified allReifiedProcesses size
