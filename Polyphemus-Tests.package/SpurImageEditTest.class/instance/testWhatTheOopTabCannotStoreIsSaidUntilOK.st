tests
testWhatTheOopTabCannotStoreIsSaidUntilOK

	"#142: a value typed into the Oop tab that cannot be stored is said in a message that stays
	until OK, not one that fades."

	| reading specials ui |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	specials := reading reifiedSpecialObjectArray.
	reading editor: (SpurEdit on: (SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit) reading: reading).
	ui := UIManagerDouble new.
	specials storeTyped: 'Object new' inItemKeyed: 'slot 1' telling: ui.
	self assert: ui alerts size equals: 1.
	self assert: ui alerts first key equals: 'Not stored'.
	self assert: (ui alerts first value includesSubstring: 'an integer, nil, true or false')
