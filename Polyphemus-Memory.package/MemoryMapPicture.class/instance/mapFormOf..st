drawing
mapFormOf: anIndex

	| map painter form |
	map := self geometryOf: anIndex.
	painter := self painterOf: anIndex.
	form := Form extent: map width @ map height depth: 32.
	0 to: map pixelCount - 1 do: [ :index |
		form bits
			at: index + 1
			put: ((self class colourOf: (painter categoryOfPixel: index)) pixelValueForDepth: 32) ].
	^ form
