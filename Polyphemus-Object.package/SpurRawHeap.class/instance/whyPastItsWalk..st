accessing
whyPastItsWalk: anAddress

	"What to add to the refusal of an address that lies, in the memory, past where the walk over
	the heap stopped on damage; nil for any other address (#211)."

	(walk notNil and: [ anAddress between: walk stoppedAt and: mappingLimit - 1 ]) ifFalse: [ ^ nil ].
	^ self whyItsHeapEndsEarly
