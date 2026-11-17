tests
testACounterSteppedFromItsLoopsFrameInTheDebuggerThenEditedCountsOn

	"The Mac trial through the debugger, on macOS: stepped from the loop's frame round the loop into
	tick:, tick: edited in the code pane, Proceed; nothing lost (#103). Linux loses nothing so."

	| pid dir session read beat later processes debugger model |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := self emptyDirectoryNamed: 'mac-debugger-counter'.
	pid := self launchTargetRunning: '| dir cls |
dir := ' , dir fullName printString , ' asFileReference.
(Object << #Counter package: ''Trial'') install.
cls := Smalltalk at: #Counter.
cls compile: ''tick: n
	^ n + 1''.
[ | n label | n := 5000.
  label := StringMorph contents: ''0''.
  (label openInWindowLabeled: ''Counter'') extent: 360 @ 160.
  [ n := cls new tick: n. label contents: n printString. (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.
[ | b | b := 0.
  [ b := b + 1.
    (dir / ''beat.part'') ensureDelete; writeStreamDo: [ :s | s print: b ].
    (dir / ''beat'') ensureDelete.
    (dir / ''beat.part'') renameTo: ''beat''.
    (Delay forMilliseconds: 50) wait ] repeat ] forkAt: 40.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 600) wait.
Smalltalk exitSuccess'.
	self assert: (self waitForFile: 'started' in: dir) description: 'the target never started'.
	read := [ :name |
	        | value |
	        "Replaced every few ms: between two versions, there is none for an instant."
	        10 timesRepeat: [
		        value ifNil: [
			        value := [ (dir / name) contents trimBoth asNumber ] on: Error do: [ :e | nil ].
			        value ifNil: [ (Delay forMilliseconds: 20) wait ] ] ].
	        value ].
	[
	Polyphemus putAWatcherInto: pid watchedIn: dir.
	session := Polyphemus holdProcess: pid watchedIn: dir.
	self assert: (session runUntil: 'Counter >> #tick:').
	debugger := StDebugger openOn: session withFullView: true.
	[
	model := PolyphemusTestCase actionModelOf: debugger.
	model stepOver: debugger session interruptedContext.
	PolyphemusTestCase drawWindowOf: debugger.
	400 timesRepeat: [
		| loop |
		debugger session interruptedContext selector = #tick: ifFalse: [
			"The loop's frame as the stack list shows it, the one the user selects."
			loop := debugger stackTable items detect: [ :each | each selector = #DoIt ] ifNone: [ nil ].
			model stepInto: (loop ifNil: [ debugger session interruptedContext ]).
			PolyphemusTestCase drawWindowOf: debugger.
			"Spec's tab bar breaks when steps come with no pause (index out of range on P13), as P10's did."
			(Delay forMilliseconds: 50) wait ] ].
	self assert: debugger session interruptedContext selector = #tick: description: 'stepping never came round to tick: again'.
	debugger
		acceptCodeChanges: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]'
		forContext: debugger session interruptedContext.
	PolyphemusTestCase drawWindowOf: debugger.
	model proceedDebugSession ] ensure: [ debugger window ifNotNil: [ :window | window close ] ].
	self assert: (self waitForFile: 'released' in: dir) description: 'it was never let go'.
	(Delay forSeconds: 2) wait.
	beat := read value: 'beat'.
	(Delay forSeconds: 2) wait.
	later := read value: 'beat'.
	self
		assert: (later notNil and: [ beat notNil and: [ later > beat ] ])
		description: [ 'the other process stopped: ' , beat printString , ' then ' , later printString ].
	processes := (Polyphemus readProcess: pid) allReifiedProcesses.
	self
		assert: (processes anySatisfy: [ :each | (Polyphemus nameOfProcess: each) = 'counter' ])
		description: 'the counter process is gone' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
