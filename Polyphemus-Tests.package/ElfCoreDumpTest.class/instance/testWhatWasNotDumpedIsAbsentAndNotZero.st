tests
testWhatWasNotDumpedIsAbsentAndNotZero

	"A region can be larger than what was written of it -- pages never touched, or left out
	on purpose. An address in that part was there and the dump does not say what it held.

	Answering zero, or the byte from the next region, would be inventing memory. The whole
	tool exists to read memory nobody can ask any more."

	| dump |
	dump := ElfCoreDump on: dumpFile.

	self assert: (dump byteAt: 16r7F000027F) equals: 16rCC.
	self assert: (dump byteAt: 16r7F0000280) isNil.
	self assert: (dump hasAddress: 16r7F000027F).
	self deny: (dump hasAddress: 16r7F0000280)
