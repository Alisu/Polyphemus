evaluating
evaluate: aSource in: aContext

	"What the held image answers for aSource evaluated in that frame, the debugger shown the image
	as it is afterwards, error or not; nil when no image runs it, a reading only (#126)."

	held ifNil: [ ^ nil ].
	^ [ held evaluate: aSource below: (self depthOf: aContext) ] ensure: [
		  [ self updateContextTo: held context ] on: Error do: [ :error | "said by the evaluation" ] ]
