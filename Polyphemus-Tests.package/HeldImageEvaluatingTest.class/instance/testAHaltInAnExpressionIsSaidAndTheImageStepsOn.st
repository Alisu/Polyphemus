tests
testAHaltInAnExpressionIsSaidAndTheImageStepsOn

	"#170: a halt is no Error, so the request did not catch it: Pharo suspended the request's
	process to open its debugger, which the held UI process never did, and it waited for 50 s."

	| pid session said started |
	pid := self launchCounter.
	[
	session := self heldAtTickOf: pid.
	started := Time millisecondClockValue.
	said := [ session evaluate: '1 halt' in: session interruptedContext. nil ] on: Error do: [ :error | error messageText ].
	self assert: Time millisecondClockValue - started < 20000 description: 'the halt was waited on'.
	self assert: (said notNil and: [ said includesSubstring: 'Halt' ]) description: [ 'not said: ' , said printString ].
	self assert: (session evaluate: 'n class name' in: session interruptedContext) printed equals: '#SmallInteger'.
	session stepOver: session interruptedContext.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
