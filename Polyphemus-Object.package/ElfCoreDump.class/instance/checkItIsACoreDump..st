initialization
checkItIsACoreDump: aHeader

	"Refuse anything else by name rather than misreading it. The first four bytes are the
	magic, then the class (2 is 64 bit), then the encoding (1 is little endian), and at
	offset 16 the type, of which 4 is a core."

	(#( 16r7F 69 76 70 ) = (aHeader first: 4) asArray) ifFalse: [
		^ self error: 'not an ELF file' ].
	(aHeader at: 5) = 2 ifFalse: [ ^ self error: 'not a 64 bit ELF file' ].
	(aHeader at: 6) = 1 ifFalse: [ ^ self error: 'not a little endian ELF file' ].
	(self unsignedFrom: aHeader at: 17 size: 2) = 4 ifFalse: [
		^ self error: 'an ELF file, but not a core dump' ]
