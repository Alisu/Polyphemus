objects
setHashBitsOf: anOop to: aHash

	^ self wordAt: anOop put: (SpurHeader withHash: aHash in: (self wordAt: anOop))
