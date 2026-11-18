tests
testTakingTheLockIsOneObserverAtATime

	"#181: reading the owner and putting ours in place is done by one observer at a time, under a
	guard made as a directory is. Another's guard is waited for; one left by an observer that died
	in between is old, and taken away. Ours is gone once the lock is taken."

	| guard |
	guard := directory / 'hold.lock.taking'.
	guard ensureCreateDirectory.
	self should: [ (HoldLock on: directory) take ] raise: HoldFailed.
	self assert: (HoldLock on: directory) owner isNil.
	(HoldLock on: directory) guardIsOldAfter: 0 seconds; take.
	self assert: (HoldLock on: directory) owner equals: PolyphemusMadeFor current processMemoryClass ownPid.
	self deny: guard exists
