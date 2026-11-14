tests
testADefectReadingWhatCalledAPageIsNotTheEndOfAStack

	"#118: a bug of our own while the context that called a page was read ended the stack at
	the page's oldest frame."

	| stacks frame layout |
	frame := (DefectiveReadDouble of: self oldestFrame) when: #oopPageCaller answer: [ 1 / 0 ].
	layout := (DefectiveReadDouble of: reifiedMemory vmLayout) when: #framesFromContext: answer: [ { frame } ].
	stacks := ReifiedStacks on: (self memoryReadThrough: layout).

	self should: [ stacks activationsOfProcess: reifiedMemory reifiedActiveProcess ] raise: ZeroDivide
