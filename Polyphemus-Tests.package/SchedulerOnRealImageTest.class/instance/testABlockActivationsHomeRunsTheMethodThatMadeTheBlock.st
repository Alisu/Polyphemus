tests
testABlockActivationsHomeRunsTheMethodThatMadeTheBlock

	"#184: a block's home is the activation its closure was made in, its outer context; the
	nearest sender running a method is the do: or repeat it was handed to."

	| blocks |
	blocks := OrderedCollection new.
	reifiedMemory allReifiedProcesses do: [ :process |
		(reifiedMemory stacks activationsOfProcess: process) do: [ :each |
			(each isBlockContext and: [
				 each closureOrNil notNil and: [ (each closureOrNil reifiedSlotAt: 1) isNilOop not ] ])
				ifTrue: [ blocks add: each ] ] ].

	self deny: blocks isEmpty.
	blocks do: [ :each |
		self assert: each outerContext notNil.
		self assert: each home method address equals: each homeMethod address ]