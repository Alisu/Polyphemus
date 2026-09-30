tests
testTheScaleIsTheSmallestPowerOfTwoThatFits

	"60 MB in a million pixels: 64 bytes a pixel, so the ruler reads round addresses."

	| fitted |
	fitted := MemoryMapGeometry from: 0 to: 60000000 fittingPixels: 1000000 width: 1000.
	self assert: fitted bytesPerPixel equals: 64.
	self assert: fitted width * fitted height <= 1000000
