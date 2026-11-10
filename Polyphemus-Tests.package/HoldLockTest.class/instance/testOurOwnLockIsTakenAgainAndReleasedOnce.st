tests
testOurOwnLockIsTakenAgainAndReleasedOnce

	(HoldLock on: directory) take; take.
	(HoldLock on: directory) release.
	self assert: (HoldLock on: directory) owner isNil.
	self assert: (directory children collect: [ :each | each basename ]) asArray equals: #(  )
