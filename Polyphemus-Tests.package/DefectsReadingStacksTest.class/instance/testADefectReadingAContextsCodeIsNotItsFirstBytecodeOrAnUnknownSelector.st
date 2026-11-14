tests
testADefectReadingAContextsCodeIsNotItsFirstBytecodeOrAnUnknownSelector

	"#118: a bug of our own reading a context's method gave pc 1 for where it starts and ends, and
	#unknownSelector. The defect is planted where the context's method is kept, and taken out."

	| memory context method |
	memory := self memory.
	context := self context.
	method := context compiledCode.
	{ #startpc -> #firstActivationPC. #endPC -> #lastActivationPC. #selector -> #oopSelector } do: [ :each |
		memory objectAt: method address put: (self defective: method in: each value).
		[ self should: [ context perform: each key ] raise: ZeroDivide description: 'a defect under ' , each key ]
			ensure: [ memory objectAt: method address put: method ] ]
