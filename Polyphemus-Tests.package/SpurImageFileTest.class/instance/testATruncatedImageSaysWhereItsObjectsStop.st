tests
testATruncatedImageSaysWhereItsObjectsStop

	"Half of candle: the heap is there and its objects read up to where the file ends,
	which the ladder says; VMMaker is not handed a file it cannot load."

	| half readability |
	half := self damagedCopyOf: PharoImageAccessor pathToCandle64Bit keeping: 103168.
	readability := (SpurRawHeap on: (self open: half)) readability.

	self assert: (readability canRead: #heap).
	self deny: (readability canRead: #objects).
	self should: [ Polyphemus readImageFile: half ] raise: SpurCannotRead
