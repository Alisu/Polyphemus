helpers
statementPutInto: aSource source: aStatement

	"That statement where the source's statements begin, after the pragmas and temporaries,
	which is where Pharo's own parser says they start."

	| body |
	body := [ (RBParser parseMethod: aSource) body ]
		        on: Error , SyntaxErrorNotification
		        do: [ :e | nil ].
	(body isNil or: [ body statements isEmpty ]) ifTrue: [ ^ aSource ].
	^ (aSource first: body statements first start - 1) , aStatement
	  , (aSource allButFirst: body statements first start - 1)
