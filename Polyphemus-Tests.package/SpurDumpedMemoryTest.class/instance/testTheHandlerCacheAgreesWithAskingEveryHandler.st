tests
testTheHandlerCacheAgreesWithAskingEveryHandler

	"The cache answers from the object's class index and format alone, where the long way
	asks all seventeen handlers. That is only sound while no two objects with the same class
	and format want different handlers -- so this checks it against the long way, on real
	objects, rather than trusting the reasoning that says it should hold.

	Every hundred-and-first object, which is ten thousand of them across the whole heap."

	| memory reified checked address seen |
	memory := dumped memory.
	reified := dumped reifiedMemory.
	checked := 0.
	seen := 0.
	address := dumped heapStart.
	[ address notNil and: [ address < dumped liveEnd ] ] whileTrue: [
		seen := seen + 1.
		(seen \\ 101 = 0 and: [ (dumped scanner isFreeChunkAt: address) not ]) ifTrue: [
			checked := checked + 1.
			self
				assert: (reified handlerForObjectAt: address)
				equals: (reified handlerToUseFor: address) ].
		address := dumped scanner objectAfter: address ].
	self assert: checked > 1000
