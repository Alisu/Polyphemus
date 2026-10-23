tests
testACountdownIsDebuggedPostMortemByItsName

	"A recursion from 100 waiting at 50, its image saved: debugged by name, n (first argument, #6)
	from 50 to 100 under Delay>>wait; three frames looked at a person's pace (clicked by a script,
	Pharo 10 and 11's inspector fell behind and looped once closed)."

	| pid memory process frames debugger |
	pid := self launchTargetDefining: 'Countdown' thenRunning: 'cls compile: ''from: n
	n = 50 ifTrue: [ (Delay forSeconds: 600) wait ].
	n = 0 ifTrue: [ ^ 0 ].
	^ 1 + (self from: n - 1)''.
[ cls new from: 100 ] forkNamed: ''countdown''.
(Delay forSeconds: 2) wait.
Smalltalk saveAs: (dir / ''countdown'') fullName.'.
	LibC system: 'kill -9 ' , pid printString.
	memory := Polyphemus readImageFile: (self spikeDirectory / 'countdown.image') fullName.
	process := Polyphemus processNamed: 'countdown' in: memory.
	frames := memory contextsOfProcess: process.
	self assert: ((frames first: 3) anySatisfy: [ :each | each selector = #wait ]).
	self
		assert: ((frames select: [ :each | each selector = #from: ]) collect: [ :each | (each tempAt: 1) asInteger ]) asArray
		equals: (50 to: 100) asArray.
	[
	debugger := Polyphemus debugProcessNamed: 'countdown' in: memory.
	{ 1. 4. debugger stackTable items size } do: [ :index |
		debugger stackTable selectIndex: index.
		(Delay forMilliseconds: 300) wait.
		PolyphemusTestCase drawWindowOf: debugger ] ] ensure: [
		(Delay forMilliseconds: 300) wait.
		debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ]
