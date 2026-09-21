helpers
statementDoingNothingPutInto: aSource

	"The source with a statement that changes nothing where its statements begin -- after the
	pragmas and the temporaries, Pharo's own parser being asked where that is. It adds
	bytecodes and no literal: an inlined selector like ifTrue: would be one, and would move
	the rest along with it."

	| body |
	body := [ (RBParser parseMethod: aSource) body ]
		        on: Error , SyntaxErrorNotification
		        do: [ :e | nil ].
	(body isNil or: [ body statements isEmpty ]) ifTrue: [ ^ aSource ].
	^ (aSource first: body statements first start - 1) , '1 + 1. '
	  , (aSource allButFirst: body statements first start - 1)
