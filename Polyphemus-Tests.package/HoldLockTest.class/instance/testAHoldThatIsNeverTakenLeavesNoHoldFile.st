tests
testAHoldThatIsNeverTakenLeavesNoHoldFile

	"#181: an interrupt not taken in time left the hold file, and the signal counted: an image
	taking it later found a hold wanted and spun for its minute with no observer there."

	| image |
	image := self aHoldThatIsNotTaken.
	self should: [ image holdWithin: 1 second ] raise: HoldFailed.
	self deny: (directory / 'hold') exists.
	self assert: (HoldLock on: directory) owner isNil.
	self assert: image isClosed
