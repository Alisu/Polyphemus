tests
testALockAnotherObserverTookSinceItWasReadIsNotTakenFromIt

	"#181: the owner was read, and when there was none, or a dead one, the lock was deleted and
	ours put in its place. An observer that took the lock in between had it deleted: both held."

	self lockOwnedBy: self aPidThatRuns.
	self should: [ (HoldLockReadBeforeAnotherTookIt on: directory) take ] raise: HoldFailed.
	self assert: (HoldLock on: directory) owner equals: self aPidThatRuns
