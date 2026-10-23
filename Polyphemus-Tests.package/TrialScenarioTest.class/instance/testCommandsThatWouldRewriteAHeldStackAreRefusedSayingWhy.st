tests
testCommandsThatWouldRewriteAHeldStackAreRefusedSayingWhy

	"Restart, Return entered value, Peel and assigning a frame's variable ended in errors in the
	observer; each is refused, saying so, and the held image is left as it was."

	| pid session debugger refusals before after |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	| step |
	step := 1.
	^ n + step''.
Smalltalk at: #PolyphemusN put: 0.
[ | n | n := 0.
  [ n := cls new tick: n.
    Smalltalk at: #PolyphemusN put: n.
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	before := (session heldProcess ask: 'Smalltalk at: #PolyphemusN') asNumber.
	debugger := StDebugger openOn: session withFullView: true.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	(PolyphemusTestCase actionModelOf: debugger) stepOver: session interruptedContext.
	PolyphemusTestCase drawWindowOf: debugger.
	refusals := OrderedCollection new.
	refusals add: (debugger code
			 evaluate: 'step := 5000'
			 onCompileError: [ :error | error ]
			 onError: [ :error | error ]).
	refusals add: ([ session restart: session interruptedContext. nil ] on: NotOnAReading do: [ :error | error ]).
	refusals add: ([ session returnValue: 5000 from: session interruptedContext. nil ] on: NotOnAReading do: [ :error | error ]).
	refusals add: ([ session peelToFirstLike: session interruptedContext. nil ] on: NotOnAReading do: [ :error | error ]).
	self
		assert: (refusals allSatisfy: [ :each | (each isKindOf: NotOnAReading) and: [ each messageText includesSubstring: 'not supported' ] ])
		description: [ 'not all refused: ' , (refusals collect: [ :each | each printString ]) asArray printString ].
	self assert: session interruptedContext selector equals: #tick:.
	self assert: (session interruptedContext tempNamed: #step) printString equals: '1'.
	(PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ].
	(Delay forSeconds: 2) wait.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	after := (session heldProcess ask: 'Smalltalk at: #PolyphemusN') asNumber.
	session resume.
	self
		assert: (after > before and: [ after < 5000 ])
		description: [ 'the counter went from ' , before printString , ' to ' , after printString ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
