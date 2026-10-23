tests
testAPingPongIsDebuggedLiveFromTheMethodItWasRunTo

	"ping: calls pong:, pong: ping:, half a second's wait in each: held live, run until pong:,
	the debugger opens there as a live session (#93), on pong: itself, its source position known,
	none of the trap's frames above it (#94); a step moves it; proceeding lets it go."

	| pid session debugger top before |
	pid := self launchTargetDefining: 'PingPong' thenRunning: 'cls compile: ''ping: n
	(Delay forMilliseconds: 500) wait.
	^ n >= 40 ifTrue: [ n ] ifFalse: [ self pong: n + 1 ]''.
cls compile: ''pong: n
	(Delay forMilliseconds: 500) wait.
	^ self ping: n + 1''.
[ [ cls new ping: 0 ] repeat ] forkNamed: ''pingpong''.'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'PingPong >> #pong:').
	[
	debugger := StDebugger openOn: session withFullView: true.
	self
		deny: (debugger session isContextPostMortem: debugger session interruptedContext)
		description: 'a live hold opened as post mortem, without its step buttons (#93)'.
	top := debugger stackTable items first.
	self assert: top selector = #pong: description: [ 'the top frame is ' , top printString , ', not pong: (#94)' ].
	self
		assert: (top pcRangeContextIsActive: true) notEmpty
		description: 'pong: runs the twin the trap compiled: no position in its source (#94)'.
	self
		deny: (debugger stackTable items anySatisfy: [ :each | each printString includesSubstring: 'ReflectiveMethod' ])
		description: 'the trap left its reflective method in the stack (#94)'.
	PolyphemusTestCase drawEachFrameOf: debugger.
	before := debugger session interruptedContext selector -> debugger session interruptedContext pc.
	(PolyphemusTestCase actionModelOf: debugger) stepOver: debugger session interruptedContext.
	self deny: debugger session interruptedContext selector -> debugger session interruptedContext pc equals: before.
	(PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ensure: [
		debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'proceeding never let it go' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
