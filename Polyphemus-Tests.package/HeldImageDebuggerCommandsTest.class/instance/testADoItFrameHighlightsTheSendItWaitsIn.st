tests
testADoItFrameHighlightsTheSendItWaitsIn

	"A frame of a DoIt the image evaluated shows where it is, as other frames do: its source is
	the DoIt's own, compiled here as a DoIt, which has no method header to parse."

	| pid session frame range |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	[
	frame := session interruptedContext sender.
	range := frame pcRangeContextIsActive: false.
	self deny: range isEmpty.
	self assert: ((frame sourceCode copyFrom: range first to: range last) includesSubstring: 'tick:') ]
		ensure: [ session resume ] ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
