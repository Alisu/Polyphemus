tests
testBreakingOnTheStackOfAHeldImageInstallsNothingInTheObserver

	"Break on stack on a frame of a held image: Pharo puts its breakpoints in the image the debugger
	runs in, the observer, where the method may be the observer's own; refused, saying why (#115)."

	| pid session debugger before refusal |
	(StDebugger includesSelector: #breakOnStack) ifFalse: [ ^ self skip: 'no Break on stack here' ].
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	before := DebugPoint all copy.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	(self spikeDirectory / 'released') ensureDelete.
	debugger := StDebugger openOn: session withFullView: true.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	[ debugger breakOnStack ] on: NotOnAReading do: [ :error | refusal := error messageText ].
	PolyphemusTestCase drawWindowOf: debugger.
	self assert: (refusal notNil and: [ refusal includesSubstring: 'runUntil:' ]) description: 'not refused, or not saying what to do instead'.
	self
		assert: (DebugPoint all copyWithoutAll: before) isEmpty
		description: [ 'installed in the observer: ' , (DebugPoint all copyWithoutAll: before) printString ].
	(PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ].
	self
		assert: ((1 to: 200) anySatisfy: [ :each |
				 (self spikeDirectory / 'released') exists or: [ (Delay forMilliseconds: 100) wait. false ] ])
		description: 'the image was never let go' ] ensure: [
		(DebugPoint all copyWithoutAll: before) do: [ :each | each remove ].
		LibC system: 'kill -9 ' , pid printString ]
