tests
testTheHandlerCacheAgreesWithAskingEveryHandler

	"The handler cache answers from class index and format alone. Checked against asking every
	handler, on every hundred-and-first object of the real heap, rather than by reasoning."

	| memory reified checked address seen |
	memory := dumped memory.
	reified := dumped reifiedMemory.
	checked := 0.
	seen := 0.
	address := dumped raw heapStart.
	[ address notNil and: [ address < dumped raw liveEnd ] ] whileTrue: [
		seen := seen + 1.
		(seen \\ 101 = 0 and: [ (dumped raw scanner isFreeChunkAt: address) not ]) ifTrue: [
			checked := checked + 1.
			self
				assert: (reified handlerForObjectAt: address)
				equals: (reified handlerToUseFor: address) ].
		address := dumped raw scanner objectAfter: address ].
	self assert: checked > 1000
