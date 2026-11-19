dumping
write: anInteger bytes: aCount on: aStream

	"Little endian, which is what the ELF header two lines up says this file is."

	aStream nextPutAll: (LittleEndian bytesOf: anInteger size: aCount)
