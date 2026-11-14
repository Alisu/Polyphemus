tests
testAContextWhosePcOrStackPointerIsNoIntegerRefusesItByNameAndHasNoHighlight

	"#196: the pc of the second context points nowhere, and asking its highlight raised; the
	stack pointer of the newest is an object."

	| contexts |
	contexts := self contextsOf: 'SessionManager>>launchSnapshot:andQuit:'.

	self assert: contexts size equals: 3.
	self should: [ (contexts at: 2) pc ] raise: NotInTheReading.
	self assert: ((contexts at: 2) pcRangeContextIsActive: false) isEmpty.
	self assert: (reifiedMemory descriptionOfContext: (contexts at: 2)) equals: 'SessionManager>>snapshot:andQuit: [block]'.
	self
		should: [ contexts first stackp ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'is no integer') ].
	self assert: contexts first pc equals: 200
