tests
testBytesReadAsTheMemoryHasThem

	self
		assert: (space bytesAt: memory nilObject count: 8) asArray
		equals: ((0 to: 7) collect: [ :each | memory memoryManager unsignedByteAt: memory nilObject + each ])
