tests
testAnExpressionThatFailsSaysTheImagesError

	"An error in the image is said as the image says it, and leaves the image held (#126)."

	| pid session said |
	pid := self launchCounter.
	[
	session := self heldAtTickOf: pid.
	said := [ session evaluate: 'n / 0' in: session interruptedContext. nil ] on: Error do: [ :error | error messageText ].
	self assert: (said includesSubstring: 'ZeroDivide').
	self assert: (session evaluate: 'n class name' in: session interruptedContext) printed equals: '#SmallInteger'.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
