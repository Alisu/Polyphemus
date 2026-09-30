tests
testAnAddressComesBackAsTheStartOfItsPixel

	#( 0 7 8 13 99 ) do: [ :offset |
		self
			assert: (map addressAt: (map pointOf: 16r1000 + offset))
			equals: 16r1000 + (offset // 8 * 8) ]
