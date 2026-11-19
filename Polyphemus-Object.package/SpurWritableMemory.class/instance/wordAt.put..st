words
wordAt: anAddress put: aWord

	^ self storeBytes: (LittleEndian bytesOf: aWord size: 8) at: anAddress
