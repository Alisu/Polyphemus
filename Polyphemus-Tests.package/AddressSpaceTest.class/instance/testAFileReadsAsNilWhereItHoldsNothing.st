tests
testAFileReadsAsNilWhereItHoldsNothing

	"#212: the same answer from a file as from bytes in hand, for an address none of its segments holds."

	| file |
	file := SpurImageFile on: PharoImageAccessor pathToCandle64Bit.
	[
	self assert: (file bytesAt: 16rFFFF00000000 count: 8) isNil.
	self assert: (file unsignedAt: 16rFFFF00000000 size: 8) isNil ] ensure: [ file close ]
