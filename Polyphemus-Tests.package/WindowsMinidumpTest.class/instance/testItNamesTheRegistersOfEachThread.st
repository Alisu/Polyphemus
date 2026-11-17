tests
testItNamesTheRegistersOfEachThread

	"The ThreadList stream: each thread's CONTEXT, its registers named as an ELF core's are. Of
	bytes written here, a register at the place Windows documents for it."

	| file dump registers |
	file := PolyphemusEdition current scratch / 'polyphemus-threads.dmp'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream |
		stream nextPutAll: (self minidumpOfAThreadWith: { (16r78 -> 7). (16r98 -> 16r7FFE0010). (16rF8 -> 16r140001000) }) ].
	dump := FileAddressSpace onDump: file.
	[
	self assert: dump processor equals: #x86_64.
	registers := dump threadRegisters.
	self assert: registers size equals: 1.
	self assert: (registers first at: #rax) equals: 7.
	self assert: (registers first at: #rsp) equals: 16r7FFE0010.
	self assert: (registers first at: #rip) equals: 16r140001000 ] ensure: [
		dump close.
		file ensureDelete ]
