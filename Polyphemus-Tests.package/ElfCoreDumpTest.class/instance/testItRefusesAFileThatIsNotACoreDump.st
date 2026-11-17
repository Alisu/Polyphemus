tests
testItRefusesAFileThatIsNotACoreDump

	"By name, rather than by misreading it, each way a file is not one: no ELF file, a 32 bit one,
	a big endian one, an ELF file that is no core, and a file too short to hold a header at all."

	| elf notACore |
	elf := [ :class :encoding :type |
	       | header |
	       header := ByteArray new: 64 withAll: 0.
	       header replaceFrom: 1 to: 4 with: #[ 16r7F 69 76 70 ].
	       header at: 5 put: class; at: 6 put: encoding.
	       self into: header at: 17 put: type size: 2.
	       header ].
	notACore := PolyphemusEdition current scratch / 'polyphemus-not-a-core'.
	{
		(ByteArray new: 128 withAll: 7) -> 'not an ELF file'.
		(elf value: 1 value: 1 value: 4) -> 'not a 64 bit ELF file'.
		(elf value: 2 value: 2 value: 4) -> 'not a little endian ELF file'.
		(elf value: 2 value: 1 value: 2) -> 'an ELF file, but not a core dump'.
		#[  ] -> 'runs past the end of the file'.
		#[ 16r7F 69 76 70 2 1 ] -> 'runs past the end of the file' } do: [ :each |
		notACore ensureDelete.
		notACore binaryWriteStreamDo: [ :stream | stream nextPutAll: each key ].
		[
		self
			should: [ ElfCoreDump on: notACore ]
			raise: UnknownFormat
			withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: each value) ] ]
			ensure: [ notACore ensureDelete ] ]
