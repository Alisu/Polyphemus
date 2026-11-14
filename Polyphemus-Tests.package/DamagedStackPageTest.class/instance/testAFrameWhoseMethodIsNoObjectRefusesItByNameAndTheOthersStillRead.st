tests
testAFrameWhoseMethodIsNoObjectRefusesItByNameAndTheOthersStillRead

	"#198: its code was answered as nil, its selector as #unknownSelector, its pcs as 1."

	| middle |
	middle := (self frames at: 2) framePointer.
	{ 16r29. self nowhere } do: [ :each |
		self while: middle - reifiedMemory wordSize holds: each do: [
			| frames damaged |
			frames := self frames.
			damaged := frames at: 2.
			self assert: frames size equals: 3.
			self
				should: [ damaged compiledCode ]
				raise: NotInTheReading
				withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'method') ].
			self assert: (reifiedMemory descriptionOfContext: damaged) equals: 'SessionManager>>an unreadable selector'.
			self assert: damaged selector equals: #unknownSelector.
			self assert: (reifiedMemory highlightRangeOf: damaged active: false) isEmpty.
			self assert: (reifiedMemory descriptionOfContext: frames last) equals: 'SessionManager>>launchSnapshot:andQuit:'.
			self assert: damaged sender equals: frames last ] ]
