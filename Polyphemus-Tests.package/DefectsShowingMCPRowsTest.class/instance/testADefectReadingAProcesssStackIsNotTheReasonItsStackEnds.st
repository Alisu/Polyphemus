tests
testADefectReadingAProcesssStackIsNotTheReasonItsStackEnds

	"#118: a bug of our own walking a process's stack, or asking why it ends, gave a row of no
	frames with the bug's text as the reason the stack ends."

	| server |
	server := PolyphemusMCPServer new.
	self
		should: [ server rowOfProcess: self process numbered: 1 in: (self defective: self memory in: #activationsOfProcess:) ]
		raise: ZeroDivide
		description: 'a defect walking its stack'.
	self
		should: [
			server
				rowOfProcess: self process
				numbered: 1
				in: ((DefectiveReadDouble of: self memory)
						 when: #stacks
						 answer: [ self defective: self memory stacks in: #whyTheStack:endsForProcess: ]) ]
		raise: ZeroDivide
		description: 'a defect asking why it ends'
