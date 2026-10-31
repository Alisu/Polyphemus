tests
testAHeapBridgedFarAwayIsNotCopiedWithItsGap

	"#133: as one ByteArray, the gap would be terabytes of zeros, an address taken as a length:
	refused by name before anything is asked of the memory manager."

	self
		should: [ (SpurRawHeap on: self copyOfAHeapBridgedFarAway) bytes ]
		raise: SpurCannotRead
		withExceptionDo: [ :e | self assert: e reason equals: #piecesTooFarApartForOneCopy ]
