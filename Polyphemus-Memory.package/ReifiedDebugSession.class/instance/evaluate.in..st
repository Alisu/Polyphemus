evaluating
evaluate: aSource in: aContext

	"What the held image answers for aSource evaluated in that frame; nil when no image runs it,
	a reading only (#126)."

	held ifNil: [ ^ nil ].
	^ held evaluate: aSource below: (self depthOf: aContext)
