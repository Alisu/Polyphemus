tests
testTheFixtureHasATopAMiddleAndABaseFrame

	| frames |
	frames := self frames.

	self assert: (frames collect: [ :each | reifiedMemory descriptionOfContext: each ]) asArray equals: #(
			'SessionManager>>newSession'
			'SessionManager>>installNewSession'
			'SessionManager>>launchSnapshot:andQuit:' ).
	self assert: frames last isBaseFrame.
	self assert: reifiedMemory stacks livePages size equals: 1
