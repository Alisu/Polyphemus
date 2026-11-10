tests
testADebuggerContextNotYetOnTheProcessIsAskedForAgain

	"#168: asked just after a hold, the image's debugger may not be at a context of the process
	yet; the walk down its senders then went past the bottom."

	| channel held before |
	channel := ScriptedChannel answering: #( nil nil nil '''not on the process: a Context / a Context''' '''not on the process: a Context / a Context''' '2' ).
	held := HeldProcess on: channel reader: nil identityHash: 7.
	before := channel asked.
	self assert: held depthOfTheDebuggersContext equals: 2.
	self assert: channel asked - before equals: 3
