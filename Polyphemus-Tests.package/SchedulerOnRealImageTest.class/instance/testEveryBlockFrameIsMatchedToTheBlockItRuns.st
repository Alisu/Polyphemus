tests
testEveryBlockFrameIsMatchedToTheBlockItRuns

	"Nothing in a compiled block points at the block in the source it came from. They
	are lined up by order, after dropping the blocks the compiler inlines, and the order
	is only believed when the file agrees with it. Every block frame of a clean image
	should line up."

	| blockFrames |
	self requireAHostThatReproducesTheFixture.
	blockFrames := self allFrames select: [ :each | each isBlockContext ].

	self assert: blockFrames size > 15.
	blockFrames do: [ :each |
		self deny: (each astScope isKindOf: OOPSnapshotScope) ]
