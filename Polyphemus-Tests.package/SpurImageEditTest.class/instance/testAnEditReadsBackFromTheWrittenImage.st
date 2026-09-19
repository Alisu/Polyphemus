tests
testAnEditReadsBackFromTheWrittenImage

	"A slot changed to a SmallInteger is in the written file, and the file still climbs
	every rung of the ladder."

	| edit specials file |
	edit := SpurImageEdit on: PharoImageAccessor pathToCandle64Bit.
	specials := edit raw specialObjectsOop.
	edit storePointer: 1 ofObject: specials value: (edit smallInteger: 42).
	edit writeTo: written.

	file := SpurImageFile on: written.
	self assert: (file unsignedAt: specials + 8 size: 8) equals: 42 * 8 + 1.
	file close.
	self assert: (Polyphemus readabilityOfImageFile: written) isFullyReadable
