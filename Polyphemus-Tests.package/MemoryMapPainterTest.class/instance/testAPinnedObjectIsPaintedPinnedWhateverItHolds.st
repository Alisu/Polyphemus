tests
testAPinnedObjectIsPaintedPinnedWhateverItHolds

	"Pinned is bit 30 of the header (VMMaker's pinnedBitShift)."

	| painter |
	painter := self painterFor: { { 40 + (1 bitShift: 30). 16. 1 } } bytesPerPixel: 8.

	self assert: (painter categoryOfPixel: 0) equals: #pinned
