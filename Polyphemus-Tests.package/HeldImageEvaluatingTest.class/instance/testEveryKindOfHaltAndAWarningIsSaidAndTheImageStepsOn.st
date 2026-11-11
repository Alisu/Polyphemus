tests
testEveryKindOfHaltAndAWarningIsSaidAndTheImageStepsOn

	"#170: what opens a debugger by default was left to Pharo in a request, which then waited
	for the held UI process: the halt family and breakpoints (Break), and a Warning too."

	| pid session |
	pid := self launchCounter.
	[
	session := self heldAtTickOf: pid.
	#( '1 halt: ''here''' '1 haltIf: true' 'Break new signal' 'Warning signal: ''careful''' ) with: #( 'Halt' 'Halt' 'Break' 'Warning' ) do: [ :source :kind |
		| started said |
		started := Time millisecondClockValue.
		said := [ session evaluate: source in: session interruptedContext. nil ] on: Error do: [ :error | error messageText ].
		self assert: Time millisecondClockValue - started < 20000 description: source , ' was waited on'.
		self assert: (said notNil and: [ said includesSubstring: kind ]) description: [ source , ' not said: ' , said printString ] ].
	self assert: (session evaluate: 'n class name' in: session interruptedContext) printed equals: '#SmallInteger'.
	session stepOver: session interruptedContext.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
