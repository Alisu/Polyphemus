tests
testAnImageThatEndsWhileHeldIsSaidAtOnce

	"The held image's process killed while its debugger is open: asking it says it is gone at
	once, and closing the debugger lets nothing wait. Each waited a minute (#127)."

	| pid session debugger started |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	debugger := StDebugger openOn: session withFullView: true.
	PolyphemusTestCase drawWindowOf: debugger.
	LibC system: 'kill -9 ' , pid printString.
	self assert: (self waitFor: [ (LibC system: 'kill -0 ' , pid printString , ' 2>/dev/null') ~= 0 ]).
	started := Time millisecondClockValue.
	self
		should: [ session heldProcess ask: '3 + 4' ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'gone') ].
	self shouldnt: [ debugger window close ] raise: Error.
	self assert: Time millisecondClockValue - started < 10000 ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
