reading
bytesAt: anAddress count: aCount

	"All the bytes or nil, as a dump answers. Read in 64 KB blocks kept for the reader's life,
	else directly where a block is not all readable (a region's edge)."

	| start |
	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	start := anAddress - (anAddress \\ 65536).
	anAddress + aCount <= (start + 65536) ifFalse: [ ^ self read: aCount at: anAddress ].
	^ (self blockAt: start)
		  ifNil: [ self read: aCount at: anAddress ]
		  ifNotNil: [ :block | block copyFrom: anAddress - start + 1 to: anAddress - start + aCount ]
