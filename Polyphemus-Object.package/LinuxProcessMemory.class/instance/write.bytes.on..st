dumping
write: anInteger bytes: aCount on: aStream

	"Little endian, which is what the ELF header two lines up says this file is."

	0 to: aCount - 1 do: [ :each |
		aStream nextPut: (anInteger bitShift: each * -8) \\ 256 ]
