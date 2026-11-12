tests
testAHoldWhoseProcessHadEndedIsTakenAgain

	"#172: once in twenty-five, the trap test's hold named a process no longer there."

	HeldImageWhoseProcessEnds endingTimes: 2.
	self assert: (HeldImageWhoseProcessEnds holding: 1 watchedIn: nil within: 1 second) class equals: HeldImageWhoseProcessEnds.
	self assert: HeldImageWhoseProcessEnds holds equals: 3
