tests
testADoItOfTheImageReadsAsItsOwnSource

	"A frame of a DoIt the image evaluated, in no class and with no source pointer: its source is
	the one the DoIt keeps itself, not the bytecode the debugger showed instead."

	| pid session frame |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	[
	frame := session interruptedContext sender.
	self assert: (frame sourceCode includesSubstring: 'forkNamed: ''counter''') ] ensure: [ session resume ] ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
