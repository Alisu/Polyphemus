tests
testASpecialObjectThatShouldBeAClassAndIsNoneIsRefusedSayingWhichOne
	<readsAnUnsoundHeap>

	"#207: special objects 7 and 17, the class of strings and the class of methods, are read for
	their class indexes before anything is reified. Holding no class, the image loads and the
	read failed in VMMaker's memory: refused by name, saying which special object."

	#( 7 17 ) do: [ :slot |
		self wordsThatAreNoClass do: [ :word |
			| refusal |
			refusal := self refusalOfACopyDamagedBy: (DamagedCandleImage slot: slot of: clean reifiedSpecialObjectArray) -> word.
			self assert: refusal level equals: #specialObjects.
			self assert: refusal reason equals: #aSpecialObjectIsNoClass.
			self assert: (refusal messageText includesSubstring: 'special object ' , slot printString , ',') ] ]
