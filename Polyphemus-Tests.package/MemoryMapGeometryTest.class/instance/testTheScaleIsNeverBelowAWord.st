tests
testTheScaleIsNeverBelowAWord

	| fitted |
	fitted := MemoryMapGeometry from: 0 to: 100 fittingPixels: 1000000 width: 1000.
	self assert: fitted bytesPerPixel equals: 8
