tests
testReadsInOnePieceAskOnlyThatPiece

	"#152: a walk reads one piece for a long stretch. The piece found for one read is asked first
	for the next, not each piece in turn."

	| pieces space |
	pieces := self pieces.
	space := SplitAddressSpace withAll: pieces.
	0 to: 7 do: [ :index |
		space unsignedAt: 16r10000 + (2 * 16r100000) + (index * 8) size: 8.
		space hasAddress: 16r10000 + (2 * 16r100000) + (index * 8) + 7 ].
	self assert: (pieces first lookups + (pieces at: 2) lookups) <= 2.
	self assert: pieces last lookups <= 17
