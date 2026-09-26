tests
testTheInspectorSetsASlotThroughTheReadingsEditor

	"Typed in the value cell of a slot, as the inspector's Oop tab takes it (#20): nil, true,
	false or an integer, stored by the editor the reading was given."

	| reading edit specials file word |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	edit := SpurEdit on: (SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit) reading: reading.
	reading editor: edit.
	specials := reading reifiedSpecialObjectArray.

	specials store: 'true' inItemKeyed: 'slot 1'.
	edit memory writeTo: written.

	file := SpurImageFile on: written.
	word := file unsignedAt: file specialObjectsOop + 8 size: 8.
	file close.
	self assert: word equals: (edit addressOf: reading reifiedTrueObject)
