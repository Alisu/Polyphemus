tests
testRunToHereInAHeldFrameStepsUntilTheSelection

	"Run to here stepped once and stopped: Pharo's own knows the frame by identity, and each step
	shows a new reading of it."

	| pid session debugger source start n |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	| a b |
	a := n + 1.
	b := a * 2.
	^ b - a''.
[ | n | n := 0.
  [ n := cls new tick: n.
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	debugger := StDebugger openOn: session withFullView: true.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	n := (session interruptedContext tempNamed: #n) printString asNumber.
	source := session interruptedContext method sourceCode.
	start := source findString: '^ b - a'.
	(PolyphemusTestCase actionModelOf: debugger)
		runToSelection: (start to: start + 6)
		inContext: session interruptedContext.
	PolyphemusTestCase drawWindowOf: debugger.
	self assert: session interruptedContext selector equals: #tick:.
	self assert: (session interruptedContext tempNamed: #b) printString equals: ((n + 1) * 2) printString.
	(PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
