writing
storeWord: aWord at: anAddress

	"Eight bytes, little endian, as #unsignedAt:size: reads them back."

	^ self storeBytes: (LittleEndian bytesOf: aWord size: 8) at: anAddress
