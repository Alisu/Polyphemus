instance creation
from: aStart to: anEnd fittingPixels: aLimit width: aWidth

	"The smallest power of two bytes a pixel, a word at least, that fits: round addresses."

	| bytes |
	bytes := 8.
	[ | map | map := self from: aStart to: anEnd bytesPerPixel: bytes width: aWidth.
	  map width * map height > aLimit ] whileTrue: [ bytes := bytes * 2 ].
	^ self from: aStart to: anEnd bytesPerPixel: bytes width: aWidth
