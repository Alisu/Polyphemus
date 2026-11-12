tests
testAnotherFailureOfTheHoldIsLeftAsItIs

	| channel |
	channel := ChannelDouble failingOn: '(self at: #hold)'.
	channel failingWith: (PolyphemusChannelError new messageText: 'Error: 2 processes have that hash').
	self
		should: [ HeldProcess on: channel reader: nil identityHash: 7 startingAt: nil ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error | self deny: (error isKindOf: ProcessEndedBeforeHeld) ]
