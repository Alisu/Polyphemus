tests
testProceedInTheDebuggerOfAHeldImageClosesIt

	"Proceed lets the held image go and closes its debugger, as Pharo's does: one left open took a
	save that went nowhere (#107)."

	| pid session debugger |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	debugger := PolyphemusTestCase inUIProcess: [ StDebugger openOn: session withFullView: true ].
	[
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].
	PolyphemusTestCase inUIProcess: [ debugger proceedDebugSession ].
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'the image was never let go'.
	self deny: (debugger window notNil and: [ debugger window isOpen ]) ] ensure: [
		PolyphemusTestCase inUIProcess: [ debugger window ifNotNil: [ :window | window isOpen ifTrue: [ window close ] ] ] ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
