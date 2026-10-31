tests
testThisImageHasPharosOwnSessionMethods

	"#143: without them Pharo opens no debugger at all, on any error."

	#( #isContextPostMortem: #isLatestContext: ) do: [ :each |
		self assert: (DebugSession includesSelector: each) description: each ]
