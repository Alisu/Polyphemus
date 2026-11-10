tests
testADebuggerContextNeverOnTheProcessSaysWhatTheImageSaw

	| held |
	held := HeldProcess on: (ScriptedChannel answering: #( nil nil nil '''not on the process: [] in Foo>>bar / Baz>>qux''' )) reader: nil identityHash: 7.
	self
		should: [ held depthOfTheDebuggersContext ]
		raise: NotInTheReading
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'Baz>>qux') ]
