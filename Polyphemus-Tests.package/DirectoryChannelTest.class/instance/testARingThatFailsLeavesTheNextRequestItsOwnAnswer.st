tests
testARingThatFailsLeavesTheNextRequestItsOwnAnswer

	"#181: a request is counted and written, then the agent rung. A ring that raised left the
	request written and counted: the next was one answer behind, and waited out its minute. The
	request is taken back, and the next asked gets its own answer."

	| failing |
	failing := true.
	channel ringing: [
		failing
			ifTrue: [
				failing := false.
				SpurCannotRead new level: #bytes reason: #itWasNeverStoppedAtASafeMoment; signal ]
			ifFalse: [ bell instVarAt: 3 put: 1 ] ].
	self should: [ channel ask: '1 + 1' ] raise: SpurCannotRead.
	self assert: (channel ask: '3 + 4' within: 5 seconds) equals: '7'
