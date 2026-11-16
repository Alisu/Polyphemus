tests
testABlockWhoseOuterCodeIsAMethodThatDoesNotHoldItIsNotSaidToBeInIt

	"#118: the block's last literal, its outer code, overwritten with the address of another
	method. The block was said to be in that method: its selector, its source, its temporaries.
	A method holds its blocks; one that does not hold this one is refused by name."

	| other |
	other := ((reifiedMemory contextsOfProcess: process) collect: [ :each | each compiledCode ]) detect: [ :each |
		         each isCompiledMethodOop and: [ each address ~= context homeMethod address ] ].
	self whileSlot: subject numberOfLiterals + 1 holds: other address do: [
		self
			should: [ reifiedMemory stacks homeMethodOf: subject ]
			raise: NotInTheReading
			withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'does not hold it') ].
		self assert: context selector equals: #unknownSelector ].
	self assert: (reifiedMemory stacks homeMethodOf: subject) isCompiledMethodOop
