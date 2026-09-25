tests
testAnEditReadsBackFromTheWrittenImage

	"A slot changed to a SmallInteger is in the written file, and the file still climbs
	every rung of the ladder."

	| memory specials file |
	memory := SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit.
	specials := memory raw specialObjectsOop.
	memory storePointer: 0 ofObject: specials withValue: (memory smallIntegerOop: 42).
	memory writeTo: written.

	file := SpurImageFile on: written.
	self assert: (file unsignedAt: specials + 8 size: 8) equals: 42 * 8 + 1.
	file close.
	self assert: (Polyphemus readabilityOfImageFile: written) isFullyReadable
