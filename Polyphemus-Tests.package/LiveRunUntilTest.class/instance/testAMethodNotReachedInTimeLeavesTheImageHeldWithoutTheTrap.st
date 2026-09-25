tests
testAMethodNotReachedInTimeLeavesTheImageHeldWithoutTheTrap

	self withASessionOn: self launchSpinningTarget do: [ :session |
		self deny: (session runUntil: 'Integer >> #gcd:' within: 3 seconds).
		self
			assert: (session heldProcess ask: '(Smalltalk globals includesKey: #PolyphemusTrap) or: [ ((Integer >> #gcd:) ast links ifNil: [ #() ]) notEmpty ]')
			equals: 'false'.
		session resume.
		self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) ]
