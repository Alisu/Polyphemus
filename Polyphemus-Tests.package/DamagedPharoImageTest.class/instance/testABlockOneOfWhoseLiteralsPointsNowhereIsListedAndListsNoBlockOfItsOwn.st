tests
testABlockOneOfWhoseLiteralsPointsNowhereIsListedAndListsNoBlockOfItsOwn

	"#208: the first literal of the block of Set>>rehash points nowhere. Listing the blocks of the
	method failed in a primitive, on the last of no literals."

	| method |
	method := (reifiedMemory oopClassNamed: 'Set') methodNamed: 'rehash' ifAbsent: [ nil ].

	self assert: method allCompiledBlocks size equals: 1.
	self should: [ method allCompiledBlocks first literalAt: 1 ] raise: NotInTheReading.
	self assert: method allCompiledBlocks first allCompiledBlocks isEmpty.
	self assert: (method allCompiledBlocks first printString beginsWith: '[...] in Set >> #rehash')
