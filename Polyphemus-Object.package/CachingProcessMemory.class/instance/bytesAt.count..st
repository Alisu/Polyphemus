reading
bytesAt: anAddress count: aCount

	"All the bytes or nil, as a dump answers: from the 64 KB block they are in, else directly
	where they cross a block or a block is not all readable (a region's edge)."

	| start |
	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	start := anAddress - (anAddress \\ 65536).
	anAddress + aCount <= (start + 65536) ifFalse: [ ^ self read: aCount at: anAddress ].
	^ (self blockAt: start)
		  ifNil: [ self read: aCount at: anAddress ]
		  ifNotNil: [ :block | block copyFrom: anAddress - start + 1 to: anAddress - start + aCount ]
