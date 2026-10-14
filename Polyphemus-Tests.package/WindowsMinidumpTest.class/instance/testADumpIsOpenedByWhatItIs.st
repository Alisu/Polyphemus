tests
testADumpIsOpenedByWhatItIs

	"One door for every dump: a minidump is read as one, an ELF core as one."

	| core read |
	read := FileAddressSpace onDump: dumpFile.
	[ self assert: read class equals: WindowsMinidump ] ensure: [ read close ].
	core := PolyphemusEdition current scratch / 'polyphemus-minidump-test.core'.
	core ensureDelete.
	core binaryWriteStreamDo: [ :stream | stream nextPutAll: ElfCoreDumpTest new coreBytes ].
	read := FileAddressSpace onDump: core.
	[ self assert: read class equals: ElfCoreDump ] ensure: [
		read close.
		core ensureDelete ]
