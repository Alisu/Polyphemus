tests
testAnotherObserversLockIsNotReleasedByUs

	self lockOwnedBy: self aPidThatRuns.
	(HoldLock on: directory) release.
	self assert: (HoldLock on: directory) owner equals: self aPidThatRuns
