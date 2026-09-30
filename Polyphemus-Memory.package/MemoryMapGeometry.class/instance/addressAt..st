mapping
addressAt: aPoint

	"The first address that pixel covers, or nil outside the map."

	| index |
	((aPoint x between: 0 and: width - 1) and: [ aPoint y >= 0 ]) ifFalse: [ ^ nil ].
	index := aPoint y * width + aPoint x.
	index < self pixelCount ifFalse: [ ^ nil ].
	^ start + (index * bytesPerPixel)
