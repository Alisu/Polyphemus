tests
testAMethodWhoseTrailerSaysMoreSourceThanItHoldsRefusesItByNameAndItsFrameHasNoHighlight

	| context |
	context := self contextsOfTheResumingProcess at: 14.

	self should: [ context homeMethod trailer ] raise: UnknownFormat.
	self should: [ context homeMethod sourceCode ] raise: UnknownFormat.
	"Where its code ends is then every byte it has: its trailer cannot be taken off."
	self assert: context homeMethod endPC equals: context homeMethod numberOfBytecodes.
	self assert: (reifiedMemory highlightRangeOf: context active: false) isEmpty.
	self assert: (reifiedMemory tempNamesOf: context) isEmpty.
	"Its bytes cannot be told from its trailer's, so its bytecodes are said not to read, with why."
	self assert: (context sourceCode beginsWith: 'bytecodes unreadable: ')
