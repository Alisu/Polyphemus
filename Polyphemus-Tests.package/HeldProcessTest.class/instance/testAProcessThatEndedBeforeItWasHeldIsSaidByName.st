tests
testAProcessThatEndedBeforeItWasHeldIsSaidByName

	"#172: the stop caught a process of a moment, our own let-go's, gone when the agent looked for
	its hash. Said by name, for the hold to be taken again."

	| channel |
	channel := ChannelDouble failingOn: '(self at: #hold)'.
	channel failingWith: (PolyphemusChannelError new messageText: 'Error: 0 processes have that hash').
	self
		should: [ HeldProcess on: channel reader: nil identityHash: 7 startingAt: nil ]
		raise: ProcessEndedBeforeHeld
