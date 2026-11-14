tests
testADefectReadingASenderIsNotTheEndOfAStack

	"#118: a bug of our own while a sender was read ended the stack there, in each of its walks."

	| stacks context process |
	stacks := self memory stacks.
	context := self defective: self context in: #reifiedSlotAt:.
	process := (DefectiveReadDouble of: self process) when: #reifiedSlotAt: answer: [ context ].

	self should: [ stacks contextsFrom: context ] raise: ZeroDivide.
	self should: [ stacks contextsOfProcess: process ] raise: ZeroDivide.
	self should: [ stacks stackFrom: (self defective: self context in: #sender) ofSize: 5 ] raise: ZeroDivide
