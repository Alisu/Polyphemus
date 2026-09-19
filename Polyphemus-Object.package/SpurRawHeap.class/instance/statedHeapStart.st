finding the heap
statedHeapStart

	"Where old space is stated to start (#statedHeapStartIn:variables:), believed only if it
	is in this mapping, nil, false and true are there by their shape, and the walk runs."

	| start |
	start := self class statedHeapStartIn: space variables: self vmVariables.
	start ifNil: [ ^ nil ].
	^ ((start between: mappingStart and: mappingLimit - 1) and: [
		   (self scanner looksLikeNilFalseAndTrueAt: start) and: [
			   self scanner looksLikeAHeapFrom: start upTo: mappingLimit ] ])
		  ifTrue: [ start ]
		  ifFalse: [ nil ]
