header
dataSize

	^ self unsignedFrom: header at: 9 size: 8
