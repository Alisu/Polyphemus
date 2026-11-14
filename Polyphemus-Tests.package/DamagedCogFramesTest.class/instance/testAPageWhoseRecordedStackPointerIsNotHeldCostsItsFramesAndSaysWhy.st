tests
testAPageWhoseRecordedStackPointerIsNotHeldCostsItsFramesAndSaysWhy

	"The VM records where the stack of each page ends. That word of the record pointing where the
	core holds nothing, the frames of the page are refused: the stack shows the context its
	newest frame was married to, and says why it ends there."

	| raw page field |
	raw := memory vmLayout raw.
	page := raw vmVariables pageWithHeadFP: self frames first framePointer.
	field := (0 to: 15)
		         collect: [ :each | page address + (each * 8) ]
		         thenSelect: [ :each | (memory vmLayout wordAt: each) = page headSP ].
	self assert: field size equals: 1.

	self while: field first holds: 16rFFE9797400 do: [
		| activations |
		activations := memory activationsOfProcess: process.
		self assert: (activations noneSatisfy: [ :each | each isStackFrame ]).
		self assert: activations size equals: 1.
		self assert: ((memory stacks whyTheStackEndsOfProcess: process) includesSubstring: 'is not in this memory') ]
