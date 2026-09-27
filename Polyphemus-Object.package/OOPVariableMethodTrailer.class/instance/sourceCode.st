accessing
sourceCode

	"The source the trailer holds itself, or nil."

	^ (kind beginsWith: 'EmbeddedSource')
		  ifTrue: [ data ]
		  ifFalse: [ nil ]
