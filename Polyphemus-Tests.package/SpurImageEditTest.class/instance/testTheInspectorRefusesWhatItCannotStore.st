tests
testTheInspectorRefusesWhatItCannotStore

	"Only what the image already holds can be stored: text that is not one of them, a row
	that is not a slot, or a reading nobody can write through are refused by name."

	| reading specials |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	specials := reading reifiedSpecialObjectArray.
	self should: [ specials store: '1' inItemKeyed: 'slot 1' ] raise: Error
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'only read') ].
	reading editor: (SpurEdit on: (SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit) reading: reading).
	self should: [ specials store: 'Object new' inItemKeyed: 'slot 1' ] raise: Error
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'an integer, nil, true or false') ].
	self should: [ specials store: '1' inItemKeyed: #hash ] raise: Error
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'not a slot') ]
