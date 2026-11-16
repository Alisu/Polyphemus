tests
testADefectReadingAProcesssNameIsNotAProcessWithoutOne

	"#118: a process whose name does not read has none. A bug of our own reading it is not that."

	| process |
	process := self memory allReifiedProcesses first.

	self should: [ Polyphemus nameOfProcess: (self defective: process in: #oopClass) ] raise: ZeroDivide
