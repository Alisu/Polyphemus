tests
testABlockWhoseHeaderCountsMoreLiteralsThanItHasSlotsRefusesThemByName

	"#208: a tagged word where the header is reads as a header counting five literals, in a block
	of five words in all. Its last literal was then read past the block's end, where VMMaker
	asserts up to Pharo 11 and the next object's header was taken for a literal from Pharo 12."

	self assert: (memory numSlotsOfAny: subject address) equals: 5.
	self whileSlot: 1 holds: 16r29 do: [
		self
			should: [ subject numberOfLiterals ]
			raise: SpurCannotRead
			withExceptionDo: [ :refusal | self assert: refusal reason equals: #itsHeaderCountsMoreLiteralsThanItHasSlots ].
		self should: [ subject lastLiteral ] raise: SpurCannotRead.
		self assert: subject printString equals: '[...] in an unreadable method' ]
