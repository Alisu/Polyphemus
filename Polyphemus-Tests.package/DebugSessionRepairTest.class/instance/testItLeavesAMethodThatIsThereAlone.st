tests
testItLeavesAMethodThatIsThereAlone

	"#143: a class that has them keeps its own: nothing is compiled again."

	| having before |
	having := DebugSession newAnonymousSubclass.
	DebugSessionRepair restoreInto: having.
	before := DebugSessionRepair originals keys collect: [ :each | having >> each ].
	DebugSessionRepair restoreInto: having.
	self assert: (DebugSessionRepair originals keys collect: [ :each | having >> each ]) equals: before
