tests
testACounterEditedLiveCountsOnAndTheImageWithIt

	"The Mac trial's counter, held, stepped, run to tick: again and tick: edited there, then let go:
	it counts on with the new code, and another process of its priority runs on with it (#103)."

	| pid dir session read count beat later |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := self emptyDirectoryNamed: 'mac-counter'.
	pid := self launchTargetRunning: '| dir cls |
dir := ' , dir fullName printString , ' asFileReference.
(Object << #Counter package: ''Trial'') install.
cls := Smalltalk at: #Counter.
cls compile: ''tick: n
	^ n + 1''.
[ | n | n := 5000.
  [ n := cls new tick: n.
    (dir / ''count.part'') ensureDelete; writeStreamDo: [ :s | s print: n ].
    (dir / ''count'') ensureDelete.
    (dir / ''count.part'') renameTo: ''count''.
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.
[ | b | b := 0.
  [ b := b + 1.
    (dir / ''beat.part'') ensureDelete; writeStreamDo: [ :s | s print: b ].
    (dir / ''beat'') ensureDelete.
    (dir / ''beat.part'') renameTo: ''beat''.
    (Delay forMilliseconds: 50) wait ] repeat ] forkAt: 40.
(Delay forSeconds: 600) wait.
Smalltalk exitSuccess'.
	read := [ :name |
	        | value |
	        "Replaced every few ms: between two versions, there is none for an instant."
	        10 timesRepeat: [
		        value ifNil: [
			        value := [ (dir / name) contents trimBoth asNumber ] on: Error do: [ :e | nil ].
			        value ifNil: [ (Delay forMilliseconds: 20) wait ] ] ].
	        value ].
	[
	self assert: (self waitForFile: 'count' in: dir) description: 'the counter never started'.
	Polyphemus putAWatcherInto: pid watchedIn: dir.
	session := Polyphemus holdProcess: pid watchedIn: dir.
	self assert: (session runUntil: 'Counter >> #tick:').
	session stepOver: session interruptedContext.
	session stepOver: session interruptedContext.
	4 timesRepeat: [ session stepOver: session interruptedContext ].
	self assert: (session runUntil: 'Counter >> #tick:') description: 'it never came round to tick: again'.
	self assert: (session
			 recompileMethodTo: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]'
			 inContext: session interruptedContext
			 notifying: nil).
	session resume.
	self assert: (self waitForFile: 'released' in: dir) description: 'it was never let go'.
	(Delay forSeconds: 2) wait.
	count := read value: 'count'.
	beat := read value: 'beat'.
	(Delay forSeconds: 2) wait.
	later := read value: 'count'.
	self
		assert: (later notNil and: [ later ~= count and: [ later <= 1010 ] ])
		description: [ 'the counter did not count on with the new code: ' , count printString , ' then ' , later printString ].
	later := read value: 'beat'.
	self
		assert: (later notNil and: [ beat notNil and: [ later > beat ] ])
		description: [ 'the other process stopped: ' , beat printString , ' then ' , later printString ] ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
