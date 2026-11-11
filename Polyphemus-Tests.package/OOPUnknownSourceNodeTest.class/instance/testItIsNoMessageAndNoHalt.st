tests
testItIsNoMessageAndNoHalt

	"Asked of a frame whose code was not reproduced, as Pharo's debugger and our tests ask a node
	(#171): Pharo 14 gave it to a test asking whether the next node is a send."

	self deny: OOPUnknownSourceNode new isMessage.
	self deny: OOPUnknownSourceNode new isHaltNode
