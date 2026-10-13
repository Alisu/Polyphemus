writing
statusNoteOf: someRegisters

	"Linux's aarch64 elf_prstatus, 392 bytes: the pid at 32, user_pt_regs at 112 (x0-x30, sp,
	pc, pstate); the rest zero."

	| description |
	description := ByteArray new: 392.
	(memory respondsTo: #pid) ifTrue: [ description unsignedLongAt: 33 put: memory pid ].
	(((0 to: 28) collect: [ :i | someRegisters at: ('x' , i printString) asSymbol ])
	 , { someRegisters at: #fp. someRegisters at: #lr. someRegisters at: #sp. someRegisters at: #pc. someRegisters at: #pstate })
		withIndexDo: [ :each :i | description unsignedLongLongAt: 112 + (i - 1 * 8) + 1 put: each ].
	^ ByteArray streamContents: [ :stream |
		  self write: 5 bytes: 4 on: stream.
		  self write: description size bytes: 4 on: stream.
		  self write: 1 bytes: 4 on: stream.
		  stream nextPutAll: 'CORE' asByteArray; nextPutAll: #[ 0 0 0 0 ].
		  stream nextPutAll: description ]
