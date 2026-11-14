tests
testAStreamOfAnEndedSessionIsOpenedAgain

	"#197: a core kept in a saved image came back holding the stream of a session that had ended,
	and every read of its file failed. Closed behind its back here, which fails the same way."

	| dump |
	dump := ElfCoreDump on: dumpFile.
	self assert: (dump unsignedAt: 16r7F0000000 size: 8) equals: 16rBBBBBBBBBBBBBBBB.

	(dump instVarNamed: 'stream') close.
	dump instVarNamed: 'cacheBytes' put: nil.
	dump instVarNamed: 'cacheStart' put: nil.

	[ self assert: (dump unsignedAt: 16r7F0000000 size: 8) equals: 16rBBBBBBBBBBBBBBBB ] ensure: [ dump close ]
