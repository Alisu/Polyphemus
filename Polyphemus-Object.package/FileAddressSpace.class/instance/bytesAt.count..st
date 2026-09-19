reading
bytesAt: anAddress count: aCount

	"The bytes at this address, or nil when the dump does not have all of them.

	All of them: a read that runs off the end of what was dumped answers nothing rather
	than a short answer that looks like a whole one. Reads that cross from one segment into
	another are not served either -- segments are not adjacent in a real dump, and a read
	that spans two of them is a question about memory that was never contiguous."

	| segment |
	segment := self segmentHolding: anAddress.
	segment ifNil: [ ^ nil ].
	(segment holdsAddress: anAddress + aCount - 1) ifFalse: [ ^ nil ].

	^ self
		  bytesAtOffset: (segment fileOffsetFor: anAddress)
		  count: aCount
