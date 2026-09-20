running
setUp

	super setUp.
	SpurDumpedMemoryTest new dumpFile exists ifFalse: [
		^ self skip: 'no core dump here; make one with bin/take-dump.sh' ].
	dumped := SpurDumpedMemoryTest dumpedMemoryOn: SpurDumpedMemoryTest new dumpFile.
	raw := dumped raw
