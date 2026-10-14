tests
testItNamesTheFilesThatWereLoaded

	"The ModuleList stream: each module's path and where it was loaded, as an ELF core's
	NT_FILE note names its mappings."

	| file dump mapped |
	file := PolyphemusEdition current scratch / 'polyphemus-modules.dmp'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream |
		stream nextPutAll: (self
				 minidumpOf: { (16r360000000 -> (ByteArray new: 16 withAll: 1)) }
				 modules: {
						 ('C:\vm\PharoConsole.exe' -> (16r7FF755A90000 -> 16r7F000)).
						 ('C:\vm\PharoVMCore.dll' -> (16r7FFAE06E0000 -> 16r541000)) }) ].
	dump := FileAddressSpace onDump: file.
	[
	mapped := dump mappedFiles.
	self assert: (mapped collect: [ :each | each path ]) asArray equals: #( 'C:\vm\PharoConsole.exe' 'C:\vm\PharoVMCore.dll' ).
	self assert: mapped last start equals: 16r7FFAE06E0000.
	self assert: mapped last stop equals: 16r7FFAE06E0000 + 16r541000.
	self assert: mapped last fileOffset equals: 0.
	self assert: (dump byteAt: 16r360000000) equals: 1 ] ensure: [
		dump close.
		file ensureDelete ]
