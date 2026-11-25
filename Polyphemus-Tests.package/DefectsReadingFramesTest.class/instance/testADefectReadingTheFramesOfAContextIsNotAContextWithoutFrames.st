tests
testADefectReadingTheFramesOfAContextIsNotAContextWithoutFrames

	"#118: a bug of our own while a married context's frames were read gave no frames, and for
	the reason its stack ends a sentence of ours. #215: frames that read go on below it, so its
	stack does not end there."

	| stacks context |
	context := self oldestFrame oopContext.
	stacks := ReifiedStacks on: (self memoryReadThrough: (self defectiveLayoutIn: #framesFromContext:)).

	self assert: (reifiedMemory stacks isMarriedContext: context).
	self should: [ stacks framesFromContext: context ] raise: ZeroDivide.
	self assert: (stacks whyTheStackEndsAfter: context) isNil
