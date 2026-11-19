words
int32At: anAddress put: anInteger

	self storeBytes: (LittleEndian bytesOf: anInteger size: 4) at: anAddress
