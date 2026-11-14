building
damagesIn: aCleanReading

	"What to overwrite in the copy, each as address -> word, found in a reading of the clean
	core; which process each damage of a frame is in is kept for the tests. A stack too shallow
	for its damage is left alone, and its test skips."

	| variables active stacks damages |
	variables := aCleanReading vmLayout raw vmVariables.
	active := aCleanReading reifiedActiveProcess.
	stacks := ((aCleanReading allReifiedProcesses reject: [ :each | each address = active address ]) collect: [ :each |
		           each -> ((aCleanReading activationsOfProcess: each) select: [ :activation | activation isStackFrame ]) ])
		          asSortedCollection: [ :a :b | a value size >= b value size ].
	Damaged := Dictionary new.
	damages := OrderedCollection with: (variables addressOf: 'framePointer') -> 16r1000.
	(stacks size >= 1 and: [ stacks first value size >= 3 ]) ifTrue: [
		Damaged at: #methodField put: stacks first key address.
		damages add: (stacks first value at: 2) framePointer - 8 -> 16r29 ].
	(stacks size >= 2 and: [ (stacks at: 2) value size >= 3 ]) ifTrue: [
		Damaged at: #savedFramePointer put: (stacks at: 2) key address.
		damages add: ((stacks at: 2) value at: 2) framePointer -> (stacks at: 2) key address ].
	^ damages
