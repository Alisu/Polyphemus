tests
testAnExpressionRunsInTheHeldFrameOnItsReceiverAndTemporaries

	"Evaluated in Counter>>tick:, self is the image's counter and n its argument: the observer has no
	class Counter (#126)."

	| pid session evaluation |
	pid := self launchCounter.
	[
	session := self heldAtTickOf: pid.
	evaluation := session evaluate: '{ self class name. n class name }' in: session interruptedContext.
	self assert: evaluation printed equals: '#(#Counter #SmallInteger)'.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
