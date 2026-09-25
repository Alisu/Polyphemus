bytes
byteAt: anAddress put: aByte

	^ self storeBytes: (ByteArray with: aByte) at: anAddress
