tests
testADefectReadingAFramesCodeIsNotItsFirstBytecodeAnUnknownSelectorOrNoTemporary

	"#118: a bug of our own reading a frame's method gave pc 1 for where it starts and ends,
	#unknownSelector, no block and no temporary. The defect is planted where the frame's method
	is kept, the frame read with it, and the defect taken out."

	| method |
	method := self oldestFrame compiledCode.
	{
		(#startpc -> #firstActivationPC).
		(#endPC -> #lastActivationPC).
		(#selector -> #oopSelector).
		(#isBlockContext -> #isCompiledBlockOop).
		(#tempAt: -> #numTemps) } do: [ :each |
		reifiedMemory
			objectAt: method address
			put: ((DefectiveReadDouble of: method) when: each value answer: [ 1 / 0 ]).
		[
		| frame |
		frame := self oldestFrame.
		self
			should: [
				each key = #tempAt:
					ifTrue: [ frame tempAt: 1 ]
					ifFalse: [ frame perform: each key ] ]
			raise: ZeroDivide
			description: 'a defect under ' , each key ] ensure: [ reifiedMemory objectAt: method address put: method ] ]
