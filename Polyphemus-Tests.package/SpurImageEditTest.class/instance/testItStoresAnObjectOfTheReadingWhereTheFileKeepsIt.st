tests
testItStoresAnObjectOfTheReadingWhereTheFileKeepsIt

	"An object is stored by its address in the file, not the reading's: true is where the
	written file's own true is, and the file still climbs every rung."

	| reading edit specials file word |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	edit := SpurEdit on: (SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit) reading: reading.
	specials := reading reifiedSpecialObjectArray.

	edit store: reading reifiedTrueObject inSlot: 5 ofObjectShown: specials.
	edit memory writeTo: written.

	file := SpurImageFile on: written.
	word := file unsignedAt: file specialObjectsOop + 40 size: 8.
	file close.
	self assert: word equals: (edit addressOf: reading reifiedTrueObject).
	self assert: (Polyphemus readabilityOfImageFile: written) isFullyReadable
