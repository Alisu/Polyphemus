mapping
pixelIndexOf: anAddress

	"Counted from the top left, row by row, from zero."

	^ anAddress - start // bytesPerPixel
