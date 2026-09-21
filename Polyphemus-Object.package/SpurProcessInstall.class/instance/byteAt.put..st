memory
byteAt: anAddress put: aByte

	^ process storeBytes: (ByteArray with: aByte) at: anAddress
