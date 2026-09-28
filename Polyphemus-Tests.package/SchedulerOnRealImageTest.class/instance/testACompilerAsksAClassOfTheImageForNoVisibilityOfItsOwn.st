tests
testACompilerAsksAClassOfTheImageForNoVisibilityOfItsOwn

	"Pharo 14's compiler maps each selector through the class's package; a class of another
	image has no package here, and its sends mean what they say."

	| class |
	class := reifiedMemory oopClassNamed: 'Integer'.

	self assert: (class package visibleSelectorForSymbol: #printString) equals: #printString.
	self assert: (class package visibleSelectorForSymbol: #at:put:) equals: #at:put:
