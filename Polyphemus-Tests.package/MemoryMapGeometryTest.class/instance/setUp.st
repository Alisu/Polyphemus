running
setUp

	super setUp.
	"4 pixels a row, 8 bytes a pixel, 100 bytes of memory from 16r1000."
	map := MemoryMapGeometry from: 16r1000 to: 16r1064 bytesPerPixel: 8 width: 4
