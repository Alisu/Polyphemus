tests
testASlotIsNotSetOnceTheImageMayHaveMovedIt

	"Held, the image still runs our agent, and a collection moves young objects: an edit aimed
	at what the last reading showed is refused once the image has collected since (#20)."

	self withTheRunawayHeldDo: [ :held :reader |
		| context |
		context := held topContext.
		held ask: 'Smalltalk garbageCollectMost. nil'.
		self
			should: [ held store: 1 inSlot: 1 ofObjectShown: context ]
			raise: Error
			withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'collected') ] ]
