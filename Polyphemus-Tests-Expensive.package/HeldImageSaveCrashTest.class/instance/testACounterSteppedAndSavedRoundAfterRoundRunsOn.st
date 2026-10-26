tests
testACounterSteppedAndSavedRoundAfterRoundRunsOn

	"Stepped round to tick:, saved there, then Proceed, round after round: the image runs on, its
	pulse too. Its VM crashed in 3 to 6 runs in 10, cause unknown (#119)."

	| pid session debugger model before after |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self windowedCounterTicking: 'tick: n
	^ n + 1' from: 5000) , self pulse.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	1 to: 5 do: [ :round |
		(self spikeDirectory / 'released') ensureDelete.
		session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
		self assert: (session runUntil: 'Counter >> #tick:').
		debugger := StDebugger openOn: session withFullView: true.
		[
		model := PolyphemusTestCase actionModelOf: debugger.
		model stepOver: debugger session interruptedContext.
		PolyphemusTestCase drawWindowOf: debugger.
		400 timesRepeat: [
			| loop |
			debugger session interruptedContext selector = #tick: ifFalse: [
				loop := debugger stackTable items detect: [ :each | each selector = #DoIt ] ifNone: [ nil ].
				model stepInto: (loop ifNil: [ debugger session interruptedContext ]).
				PolyphemusTestCase drawWindowOf: debugger ] ].
		1 timesRepeat: [
			debugger
				acceptCodeChanges: 'tick: n
	^ n + ' , round printString
				forContext: debugger session interruptedContext.
			PolyphemusTestCase drawWindowOf: debugger ].
		model proceedDebugSession ] ensure: [ debugger window ifNotNil: [ :window | window close ] ].
		self
			assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
			description: 'round ' , round printString , ': it was never let go'.
		(Delay forSeconds: 1) wait.
		before := self valueIn: 'pulse'.
		(Delay forSeconds: 2) wait.
		after := self valueIn: 'pulse'.
		self
			assert: (after notNil and: [ before notNil and: [ after > before ] ])
			description: [
				'round ' , round printString , ', the image''s pulse stopped: ' , before printString , ' then '
				, after printString , ' -- ' , (self processesOf: pid) ] ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
