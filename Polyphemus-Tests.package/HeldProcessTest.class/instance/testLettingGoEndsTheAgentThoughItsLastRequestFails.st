tests
testLettingGoEndsTheAgentThoughItsLastRequestFails

	"Putting the process back may fail; the agent must end all the same, or the image stays held."

	| channel held |
	channel := ChannelDouble failingOn: '(self at: #letGo)'.
	held := HeldProcess on: channel reader: nil identityHash: 7.
	self should: [ held letGo ] raise: Error.
	self assert: channel wasLetGo
