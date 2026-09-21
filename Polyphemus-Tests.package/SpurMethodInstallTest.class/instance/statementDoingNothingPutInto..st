helpers
statementDoingNothingPutInto: aSource

	"The source with a statement that changes nothing where its statements begin, which is
	after the pragmas and the temporaries and is Pharo's own parser's opinion. It compiles to
	a few bytecodes and no literal of its own: nil, nil, a special send, a jump."

	| body |
	body := [ (RBParser parseMethod: aSource) body ]
		        on: Error , SyntaxErrorNotification
		        do: [ :e | nil ].
	(body isNil or: [ body statements isEmpty ]) ifTrue: [ ^ aSource ].
	^ (aSource first: body statements first start - 1) , 'nil == nil ifTrue: [ ]. '
	  , (aSource allButFirst: body statements first start - 1)
