tests
testACogCompiledMethodShowsItsMachineCodeOthersShowNone

	"#95: Counter>>tick:, sent every 20 ms, is Cog compiled: its CogMethod is shown, read only: its
	header, its map from machine code pcs to bytecode pcs, its bytes. A method never run, none."

	| pid memory method text inspector |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	(Delay forSeconds: 1) wait.
	memory := Polyphemus readProcess: pid.
	method := (memory oopClassNamed: 'Counter') methodNamed: #tick:.
	text := method machineCodeText.
	self assert: text notNil description: 'tick: has no machine code'.
	self assert: (text includesSubstring: 'Counter >> #tick:') description: [ text ].
	self assert: (text includesSubstring: 'arguments 1') description: [ text ].
	self assert: (text includesSubstring: '-> bytecode pc ') description: [ text ].
	self assert: (text includesSubstring: 'Bytes') description: [ text ].
	self assert: ((memory oopClassNamed: 'Integer') methodNamed: #asWords) machineCodeText isNil.
	inspector := PolyphemusTestCase inUIProcess: [
		             ((Smalltalk globals at: #StInspectorPresenter ifAbsent: [ Smalltalk globals at: #StInspector ])
			             onObject: method) open; yourself ].
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: inspector ] ] ensure: [
		inspector ifNotNil: [ PolyphemusTestCase closeWindowOf: inspector ].
		LibC system: 'kill -9 ' , pid printString ]
