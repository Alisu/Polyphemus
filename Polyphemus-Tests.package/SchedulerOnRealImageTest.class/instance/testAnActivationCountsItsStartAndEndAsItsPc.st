tests
testAnActivationCountsItsStartAndEndAsItsPc

	"#184: a pc counts from the start of its code object, header and literals in; startpc and
	endPC counted bytecodes from one, so pc = startpc never held. One numbering, Pharo's."

	| activations |
	activations := OrderedCollection new.
	reifiedMemory allReifiedProcesses do: [ :process |
		activations addAll: (reifiedMemory stacks activationsOfProcess: process) ].

	self deny: activations isEmpty.
	activations do: [ :each |
		self
			assert: each startpc
			equals: each compiledCode numberOfLiterals + 1 * reifiedMemory wordSize + 1.
		each pc ifNotNil: [ :pc | self assert: (pc between: each startpc and: each endPC + 1) ] ]