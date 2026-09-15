tests
testAReadRunningPastWhatWasDumpedAnswersNothing

	"A short answer that looks like a whole one is the dangerous kind. Asking for eight
	bytes and getting four back, silently, would put half an oop into an arithmetic."

	| dump |
	dump := ElfCoreDump on: dumpFile.

	self assert: (dump bytesAt: 16r7F0000278 count: 8) size equals: 8.
	self assert: (dump bytesAt: 16r7F000027C count: 8) isNil.
	self assert: (dump unsignedAt: 16r7F0000000 size: 8) equals: 16rBBBBBBBBBBBBBBBB
