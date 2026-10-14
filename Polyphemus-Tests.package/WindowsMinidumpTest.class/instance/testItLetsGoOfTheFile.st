tests
testItLetsGoOfTheFile

	| dump |
	dump := WindowsMinidump on: dumpFile.
	dump byteAt: 16r10000000000.
	dump close.
	dumpFile delete.
	self deny: dumpFile exists
