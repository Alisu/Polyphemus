tests
testItLetsGoOfTheFile

	"The stream is kept open because a heap walk asks for millions of small reads and opening
	the file for each one would make that hopeless. Kept open means it has to be closeable,
	and reading after closing has to work rather than fail."

	| dump |
	dump := ElfCoreDump on: dumpFile.
	self assert: (dump byteAt: 16r400000) equals: 16rAA.

	dump close.

	self assert: (dump byteAt: 16r400000) equals: 16rAA.
	dump close
