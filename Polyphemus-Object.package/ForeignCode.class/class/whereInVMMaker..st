describing
whereInVMMaker: anException

	"Where VMMaker raised that error, for a refusal's detail: its first three methods under the
	simulator's set-up and the one that raised, with the error."

	| steps |
	steps := self vmMakerStepsOf: anException.
	^ String streamContents: [ :stream |
		  stream nextPutAll: 'VMMaker''s '.
		  (steps first: (3 min: steps size)) do: [ :each | stream nextPutAll: each ] separatedBy: [ stream nextPutAll: ' > ' ].
		  steps size > 3 ifTrue: [ stream nextPutAll: ' > ... > ' , steps last ].
		  stream nextPutAll: ': ' , anException class name , ' ' , anException messageText asString ]
