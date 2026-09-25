helpers
patchEvenIn: aDumpedMemory through: aReader

	"SmallInteger>>even, with its = 0 made = 1: the same length and the same literals, so the
	new code fits where the old sat. Answers whether the machine had compiled that method,
	whose machine code is what runs until something discards it."

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
		assert: (reading host: old matchesOop: method)
		description: 'the image does not hold the code that was compiled from'.
	(SpurEdit on: (SpurWritableProcess on: aReader) reading: reading)
		replaceCodeOfMethodShown: method from: old to: new.
	^ ((aDumpedMemory raw scanner slotOf: method address at: 1) bitAnd: 7) ~= 1
