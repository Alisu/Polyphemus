tests
testADefectReadingWhatCalledAnActivationIsNotAReasonItsStackEnds

	"#118: the reason a stack ends is made of what the reading refuses; a bug of our own on the
	way is not one of them."

	| stacks |
	stacks := self memory stacks.

	self should: [ stacks whyTheStackEndsAfter: (self defective: self context in: #sender) ] raise: ZeroDivide.
	self should: [ stacks whyTheStackEnds: { (self defective: self context in: #sender) } ] raise: ZeroDivide.
	self
		should: [ stacks whyNoActivationOfProcess: (self defective: self process in: #reifiedSlotAt:) ]
		raise: ZeroDivide.
	self
		should: [
			(ReifiedStacks on: (self defective: self memory in: #reifiedActiveProcess)) whyNoActivationOfProcess:
				((DefectiveReadDouble of: self process) when: #reifiedSlotAt: answer: [ self memory reifiedNilObject ]) ]
		raise: ZeroDivide
