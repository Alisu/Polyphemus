tests
testItStoresAnObjectOfTheReadingWhereTheFileKeepsIt

	"An object is stored by its address in the file, not the reading's: true is where the
	written file's own true is, and the file still climbs every rung."

	| reading edit specials file word |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	edit := (SpurImageEdit on: PharoImageAccessor pathToCandle64Bit) reading: reading.
	specials := reading reifiedSpecialObjectArray.

	edit store: reading reifiedTrueObject inSlot: 1 ofObjectShown: specials.
	edit writeTo: written.

	file := SpurImageFile on: written.
	word := file unsignedAt: file specialObjectsOop + 8 size: 8.
	file close.
	self assert: word equals: (edit addressInFileOf: reading reifiedTrueObject).
	self assert: (Polyphemus readabilityOfImageFile: written) isFullyReadable
