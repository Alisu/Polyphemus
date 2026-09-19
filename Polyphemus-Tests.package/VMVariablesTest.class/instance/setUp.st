running
setUp

	super setUp.
	SpurDumpedMemoryTest new dumpFile exists ifFalse: [
		^ self skip: 'no core dump here; make one with bin/take-dump.sh' ].
	dump := ElfCoreDump on: SpurDumpedMemoryTest new dumpFile.
	variables := VMVariables on: dump
