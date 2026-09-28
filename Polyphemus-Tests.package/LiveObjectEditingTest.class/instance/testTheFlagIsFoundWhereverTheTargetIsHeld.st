tests
testTheFlagIsFoundWhereverTheTargetIsHeld

	"A hold stops the target at a quiet moment, which may be the loop's own backward jump, outside
	any do: it runs. The flag is found there too: once in about a thousand holds it was not."

	| pid session |
	pid := self launchFlagTargetLooping: 'flag size'.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: ((self flagIn: session) reifiedSlotAt: 1) asInteger equals: 1.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
