mapping
pixelsOf: anAddress size: aCount

	^ (self pixelIndexOf: anAddress) to: (self pixelIndexOf: anAddress + aCount - 1)
