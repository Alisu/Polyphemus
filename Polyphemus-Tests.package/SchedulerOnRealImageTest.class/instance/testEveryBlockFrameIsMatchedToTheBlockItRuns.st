tests
testEveryBlockFrameIsMatchedToTheBlockItRuns

	"Compiled blocks are matched to source blocks by order, dropping inlined ones, and only when
	the file agrees. Every block frame of a clean image should match."

	| blockFrames |
	blockFrames := self allFrames select: [ :each | each isBlockContext ].

	self assert: blockFrames size > 15.
	blockFrames do: [ :each |
		self deny: (each astScope isKindOf: OOPSnapshotScope) ]
