drawing
mapForm

	| map |
	map := Form extent: self geometry width @ self geometry height depth: 32.
	0 to: self geometry pixelCount - 1 do: [ :index |
		map bits
			at: index + 1
			put: ((self class colourOf: (painter categoryOfPixel: index)) pixelValueForDepth: 32) ].
	^ map
