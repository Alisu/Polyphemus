bytes
bytesAt: anAddress count: aCount

	^ (0 to: aCount - 1) collect: [ :each | memory byteAt: anAddress + each ]
