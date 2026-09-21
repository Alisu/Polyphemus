helpers
makeEvenOdd: aDumpedMemory through: aReader

	"SmallInteger>>even, with its = 0 made = 1: the same length and the same literals, so the
	new code fits where the old sat. Refused unless the image holds what the old compilation
	says it does, and unless the machine has left that method alone."

	| reading class method source old new |
	reading := aDumpedMemory reifiedMemory.
	class := reading oopClassNamed: 'SmallInteger'.
	method := class methodNamed: 'even'.
	source := [ method getSourceFromFile ] on: Error do: [ :e | nil ].
	source ifNil: [ ^ self fail: 'the target image has no source for SmallInteger>>even' ].
	old := (reading compileHostSource: source for: class) first.
	new := (reading
		        compileHostSource: (source copyReplaceAll: '= 0' with: '= 1')
		        for: class) first.
	self
		assert: ((aDumpedMemory raw scanner slotOf: method address at: 1) bitAnd: 7) = 1
		description: 'the machine had compiled that method, and its code is not the bytecodes'.
	self
		assert: (reading host: old matchesOop: method)
		description: 'the image does not hold the code that was compiled from'.
	(SpurProcessEdit on: aReader)
		reading: reading;
		replaceCodeOfMethodShown: method from: old to: new
