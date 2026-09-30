painting
paint: aCategory from: anAddress size: aCount

	| code last |
	code := self codeOf: aCategory.
	last := geometry pixelCount - 1.
	((geometry pixelIndexOf: anAddress) max: 0) to: ((geometry pixelIndexOf: anAddress + aCount - 1) min: last) do: [ :pixel |
		| pixelStart covered |
		pixelStart := geometry start + (pixel * geometry bytesPerPixel).
		covered := (anAddress + aCount min: pixelStart + geometry bytesPerPixel) - (anAddress max: pixelStart).
		self add: covered bytesOf: code at: anAddress to: pixel ]
