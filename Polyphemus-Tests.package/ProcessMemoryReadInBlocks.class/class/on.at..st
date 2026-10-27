instance creation
on: aByteArray at: anAddress

	^ self new setSpace: (ByteArrayAddressSpace on: aByteArray at: anAddress)
