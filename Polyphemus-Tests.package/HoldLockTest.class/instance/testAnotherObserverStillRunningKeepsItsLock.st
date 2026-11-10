tests
testAnotherObserverStillRunningKeepsItsLock

	"#163, risk 7: two observers on one directory both rang, their requests overwrote each other."

	self lockOwnedBy: self aPidThatRuns.
	self should: [ (HoldLock on: directory) take ] raise: HoldFailed.
	self assert: (HoldLock on: directory) owner equals: self aPidThatRuns
