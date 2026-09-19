tests
testTheNewestFrameOfAPageKeepsAllItsOperands

	"#10: a page holding one frame lost its last operand, taken for a saved ip kept by a
	frame above it, which it does not have. The VM's page record says how many there are."

	| layout checked |
	layout := memory vmLayout.
	checked := 0.
	memory allReifiedProcesses do: [ :each |
		| stack page |
		stack := memory activationsOfProcess: each.
		(stack notEmpty and: [ stack first isStackFrame ]) ifTrue: [
			page := layout raw vmVariables pageWithHeadFP: stack first framePointer.
			self
				assert: stack first operandStack size
				equals: (layout firstTemporaryAddressOf: stack first framePointer) - page headSP
					// memory wordSize.
			checked := checked + 1 ] ].

	self assert: checked >= 12
