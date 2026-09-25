tests
testItRunsUntilAMethodAndStopsInIt

	"The debugger opens in the method, in the process that reached it -- the runaway, whose
	loop calls it -- and the trap is gone once it has fired."

	self withASessionOn: self launchSpinningTarget do: [ :session |
		self assert: (session runUntil: 'Integer >> #sqrt').
		self assert: session interruptedContext selector asString equals: 'sqrt'.
		self
			assert: (session heldProcess ask:
					 '((self at: #process) suspendedContext findContextSuchThat: [ :each | each selector == #timesRepeat: ]) notNil')
			equals: 'true'.
		self
			assert: (session heldProcess ask: '(Smalltalk globals includesKey: #PolyphemusTrap) or: [ ((Integer >> #sqrt) ast links ifNil: [ #() ]) notEmpty ]')
			equals: 'false'.
		session resume.
		self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) ]
