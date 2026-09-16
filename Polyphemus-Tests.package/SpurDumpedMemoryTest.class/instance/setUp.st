running
setUp

	"The dump is built once for the whole class. Carrying a hundred megabytes of mapping
	into a region takes a minute, and nothing here writes to it, so paying that per test
	would be five minutes of copying to no purpose."

	super setUp.
	self dumpFile exists ifFalse: [
		^ self skip: 'no core dump here; make one with bin/take-dump.sh' ].
	dumped := self class dumpedMemoryOn: self dumpFile
