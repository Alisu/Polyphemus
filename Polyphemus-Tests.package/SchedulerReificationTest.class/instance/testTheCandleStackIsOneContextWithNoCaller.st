tests
testTheCandleStackIsOneContextWithNoCaller

	"Read as a snapshot, nothing is married: the candle image was bootstrapped and
	never run, so its one context has no caller at all."

	| stack |
	stack := reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess.

	self assert: stack size equals: 1.
	self assert: stack first isContextOop.
	self deny: (reifiedMemory isMarriedContext: stack first).
	self assert: reifiedMemory marriedContexts isEmpty.
	self assert: reifiedMemory contextInconsistencies isEmpty
