tests
testADefectReadingAContextIsNotAnInconsistencyOfItsStack

	"#118: a bug of our own reading a context's sender or method was reported as the image's.
	The walk reads the sender twice and ends on nil; the report then reads it again."

	| real stacks context process reads |
	real := self context.
	#( #sender #method ) do: [ :failing |
		reads := 0.
		context := (DefectiveReadDouble of: real) when: #reifiedSlotAt: answer: [ :index |
			           index = self memory stacks contextSenderSlot
				           ifTrue: [
					           (reads := reads + 1) > 2 & (failing = #sender)
						           ifTrue: [ 1 / 0 ]
						           ifFalse: [ self memory reifiedNilObject ] ]
				           ifFalse: [
					           failing = #method
						           ifTrue: [ 1 / 0 ]
						           ifFalse: [ real reifiedSlotAt: index ] ] ].
		process := (DefectiveReadDouble of: self process) when: #reifiedSlotAt: answer: [ context ].
		stacks := ReifiedStacks on:
			          ((DefectiveReadDouble of: self memory) when: #allReifiedProcesses answer: [ { process } ]).
		self should: [ stacks contextInconsistencies ] raise: ZeroDivide description: 'a defect reading its ' , failing ]
