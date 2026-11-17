accessing
whyItsHeapEndsEarly

	"What to add to a refusal when the heap was taken to end where a walk over it stopped on
	damage, the VM not saying where it ends; nil when no walk stopped short (#211)."

	(walk notNil and: [ walk reachedTheLimit not ]) ifFalse: [ ^ nil ].
	^ ': the walk over the heap stopped at 16r' , walk stoppedAt printStringHex , ' (' , walk reason
	  , '), and what is past it was not read'
