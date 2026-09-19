running
setUp

	super setUp.
	SpurDumpedMemoryTest new dumpFile exists ifFalse: [
		^ self skip: 'no core dump here; make one with bin/take-dump.sh' ].
	memory := self class memory
