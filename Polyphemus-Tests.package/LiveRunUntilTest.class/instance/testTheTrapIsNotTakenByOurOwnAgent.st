tests
testTheTrapIsNotTakenByOurOwnAgent

	"#48: our agent sends SmallInteger>>even as it serves, and the target's own loop never does.
	The trap lets the agent through, so the method is simply not reached."

	self withASessionOn: self launchSpinningTarget do: [ :session |
		self deny: (session runUntil: 'SmallInteger >> #even' within: 3 seconds).
		session resume.
		self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) ]
