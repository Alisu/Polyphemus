tests
testTheCandleStackReadsAsAMethodName

	"Same description on a bootstrap image, whose classes are named PC-something."

	| lines |
	lines := reifiedMemory stackDescriptionOfProcess: reifiedMemory reifiedActiveProcess.

	self assert: lines size equals: 1.
	self assert: (lines first includesSubstring: '>>').
	self deny: (lines first endsWith: '>>')
