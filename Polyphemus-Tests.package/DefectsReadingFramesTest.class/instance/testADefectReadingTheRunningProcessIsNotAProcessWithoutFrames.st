tests
testADefectReadingTheRunningProcessIsNotAProcessWithoutFrames

	"#118: a bug of our own while the running process's frames were read gave it none."

	| stacks |
	stacks := ReifiedStacks on: (self memoryReadThrough: (self defectiveLayoutIn: #framesOfActiveProcess)).

	self should: [ stacks framesOfProcessWithoutContext: reifiedMemory reifiedActiveProcess ] raise: ZeroDivide
