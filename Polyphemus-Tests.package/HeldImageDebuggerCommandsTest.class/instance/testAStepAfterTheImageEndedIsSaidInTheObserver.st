tests
testAStepAfterTheImageEndedIsSaidInTheObserver

	"A step pressed in the debugger once the held image's process ended: said in the observer, as
	refusals are, where it only went to the terminal and PharoDebug.log (#127)."

	| pid session debugger gone |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	debugger := StDebugger openOn: session withFullView: true.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	LibC system: 'kill -9 ' , pid printString.
	self assert: (self waitFor: [ (LibC system: 'kill -0 ' , pid printString , ' 2>/dev/null') ~= 0 ]).
	[ (PolyphemusTestCase actionModelOf: debugger) stepOver: session interruptedContext ]
		on: PolyphemusChannelError
		do: [ :error | gone := error ].
	self assert: gone class equals: HeldImageGone.
	self assert: (gone messageText includesSubstring: 'gone') ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
