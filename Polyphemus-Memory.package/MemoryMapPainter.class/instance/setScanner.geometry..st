initialization
setScanner: aSpurHeapScanner geometry: aMemoryMapGeometry

	scanner := aSpurHeapScanner.
	geometry := aMemoryMapGeometry.
	winners := ByteArray new: geometry pixelCount.
	winnerBytes := Array new: geometry pixelCount withAll: 0.
	winnerAddresses := Array new: geometry pixelCount
