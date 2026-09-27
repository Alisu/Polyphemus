tests
testTheNewestFrameOfAPageKeepsAllItsOperands

	"#10: a lone frame's last operand was taken for a saved ip it does not have. The page record
	says how many there are; the running process's record is stale, so it is left out. 12 or
	more checked in the VM 9 dump, 10 in the VM 10 one."

	| layout checked |
	layout := memory vmLayout.
	checked := 0.
	(memory allReifiedProcesses reject: [ :each | each address = memory reifiedActiveProcess address ])
		do: [ :each |
		| stack page |
		stack := memory activationsOfProcess: each.
		(stack notEmpty and: [ stack first isStackFrame ]) ifTrue: [
			page := layout raw vmVariables pageWithHeadFP: stack first framePointer.
			self
				assert: stack first operandStack size
				equals: (layout firstTemporaryAddressOf: stack first framePointer) - page headSP
					// memory wordSize.
			checked := checked + 1 ] ].

	self assert: checked >= 8
