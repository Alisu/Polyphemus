tests
testEachPixelTakesItsCategorysColour

	| origin |
	origin := picture mapOrigin.
	self
		assert: (picture form pixelValueAt: origin)
		equals: ((MemoryMapPicture colourOf: #pointers) pixelValueForDepth: 32).
	self
		assert: (picture form pixelValueAt: origin + (2 @ 0))
		equals: ((MemoryMapPicture colourOf: #bytes) pixelValueForDepth: 32)
