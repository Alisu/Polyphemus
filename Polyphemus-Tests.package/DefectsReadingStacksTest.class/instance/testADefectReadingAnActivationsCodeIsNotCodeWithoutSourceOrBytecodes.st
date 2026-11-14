tests
testADefectReadingAnActivationsCodeIsNotCodeWithoutSourceOrBytecodes

	"#118: a bug of our own reading an activation's source or bytecodes gave no source, or a line
	saying the bytecodes were unreadable."

	| stacks context |
	stacks := self memory stacks.
	context := self context.

	self
		should: [
			stacks sourceOfContext: ((DefectiveReadDouble of: context)
					 when: #compiledCode
					 answer: [ self defective: context compiledCode in: #sourceCode ]) ]
		raise: ZeroDivide.
	self should: [ stacks disassemblyOfContext: (self defective: context in: #compiledCode) ] raise: ZeroDivide
