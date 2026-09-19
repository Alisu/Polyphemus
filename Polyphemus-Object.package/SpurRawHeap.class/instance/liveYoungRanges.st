young objects
liveYoungRanges

	"Past space from its start to pastSpaceStart, eden from its start to freeStart, as the
	VM kept them; nil unless both lie in the new space we found by shape."

	^ [
	  | variables ranges |
	  variables := self vmVariables.
	  ranges := {
		            ((variables boundsOf: 'pastSpace') key -> (variables at: 'pastSpaceStart')).
		            ((variables boundsOf: 'eden') key -> (variables at: 'freeStart')) }.
	  (ranges allSatisfy: [ :each |
		   self youngSpaceStart <= each key and: [
			   each key <= each value and: [ each value <= self heapStart ] ] ])
		  ifTrue: [ ranges ]
		  ifFalse: [ nil ] ]
		  on: Error
		  do: [ :e | nil ]
