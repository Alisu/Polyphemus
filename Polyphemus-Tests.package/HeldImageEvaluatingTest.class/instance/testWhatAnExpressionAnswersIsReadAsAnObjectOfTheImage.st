tests
testWhatAnExpressionAnswersIsReadAsAnObjectOfTheImage

	"The object an expression answers is read from the image as it is now: a string it made, a
	SmallInteger (#126)."

	| pid session string integer |
	pid := self launchCounter.
	[
	session := self heldAtTickOf: pid.
	string := session evaluate: '''seen '' , n printString' in: session interruptedContext.
	self assert: string object isStringOop.
	self assert: '''' , string object asString , '''' equals: string printed.
	integer := session evaluate: 'n * 2' in: session interruptedContext.
	self assert: integer object isImmediateOop.
	self assert: integer object asInteger printString equals: integer printed.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
