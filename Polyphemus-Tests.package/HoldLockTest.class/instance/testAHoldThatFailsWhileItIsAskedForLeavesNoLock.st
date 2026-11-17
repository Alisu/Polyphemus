tests
testAHoldThatFailsWhileItIsAskedForLeavesNoLock

	"#181: the lock is taken first; an error while the image is stopped to be asked (nothing
	watches, it would not stop) kept it, and the reader open, until this observer ended."

	| image |
	image := self aHoldThatIsNotTaken.
	image refuseTheRing.
	self should: [ image holdWithin: 1 second ] raise: HoldFailed.
	self assert: (HoldLock on: directory) owner isNil.
	self assert: image isClosed.
	self deny: (directory / 'hold') exists
