tests
testTheLockOfAnObserverThatDiedIsTakenOver

	self lockOwnedBy: 2147483646.
	(HoldLock on: directory) take.
	self assert: (HoldLock on: directory) owner equals: PolyphemusMadeFor current processMemoryClass ownPid
