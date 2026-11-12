tests
testAnImageWhoseProcessesAllEndIsRefusedAfterThreeHolds

	HeldImageWhoseProcessEnds endingTimes: 9.
	self should: [ HeldImageWhoseProcessEnds holding: 1 watchedIn: nil within: 1 second ] raise: ProcessEndedBeforeHeld.
	self assert: HeldImageWhoseProcessEnds holds equals: 3
