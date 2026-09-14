tests
testACleanImageReportsNoStackInconsistency

	"Sender chains of a working image end at nil, never at an integer and never in a
	loop."

	self assert: reifiedMemory contextInconsistencies isEmpty
