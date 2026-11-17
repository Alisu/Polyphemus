tests
testAHandleIsKeptWhenLettingGoOrStoppingFails

	"#180: the handle was forgotten before the image was let go: when that failed, nothing was
	left to try again with."

	#( 'let_go' 'stop' ) do: [ :tool |
		| handle result failing |
		failing := (DefectiveReadDouble of: Object new)
			           when: #letTheImageGo answer: [ HoldFailed signal: 'the image did not answer' ];
			           when: #stopTheHeldProcess answer: [ HoldFailed signal: 'the image did not answer' ];
			           yourself.
		handle := self heldBy: failing.
		result := self resultOf: tool with: (Dictionary new at: 'handle' put: handle; yourself).
		self assert: (result at: 'isError').
		self assert: (self server images includesKey: handle) description: tool ]