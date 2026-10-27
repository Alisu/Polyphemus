tests
testLettingGoAHoldThatEndedByItselfIsQuiet

	"The agent ended after its limit and put the process back itself: closing the debugger then
	asks nothing of it."

	| channel held |
	channel := ChannelDouble failingOn: '(self at: #letGo)'.
	held := HeldProcess on: channel reader: nil identityHash: 7.
	channel expire.
	held letGo.
	self deny: channel wasLetGo
