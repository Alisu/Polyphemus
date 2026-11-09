tests
testAnExpressionThatNeverEndsIsStoppedAndTheImageServesOn

	"#161: run by the agent itself, at 70, an expression that never ended held the image for good.
	Run apart and stopped at the request limit, it says so, and the held image answers on."

	| pid session said |
	pid := self launchCounter.
	PolyphemusAgent requestLimit: 3 seconds.
	[
	session := self heldAtTickOf: pid.
	said := [ session evaluate: '[ true ] whileTrue' in: session interruptedContext. nil ]
		        on: Error
		        do: [ :error | error messageText ].
	self assert: (said notNil and: [ said includesSubstring: 'stopped after' ]) description: [ said printString ].
	self assert: (session evaluate: 'n class name' in: session interruptedContext) printed equals: '#SmallInteger'.
	session resume ] ensure: [
		PolyphemusAgent requestLimit: nil.
		LibC system: 'kill -9 ' , pid printString ]
