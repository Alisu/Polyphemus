reading
bytesAt: anAddress count: aCount

	"The bytes at this address, or nil unless the file holds all of them. Reads crossing from one
	segment into another are refused: segments are not adjacent in memory."

	| segment |
	segment := self segmentHolding: anAddress.
	segment ifNil: [ ^ nil ].
	(segment holdsAddress: anAddress + aCount - 1) ifFalse: [ ^ nil ].

	^ self
		  bytesAtOffset: (segment fileOffsetFor: anAddress)
		  count: aCount
