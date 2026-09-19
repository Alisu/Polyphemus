contexts
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame to the oldest. Empty
	when the context has no frame, as in every snapshot."

	([ self isMarriedContext: aContext ] on: Error do: [ :e | false ]) ifFalse: [ ^ #(  ) ].
	^ [ self vmLayout framesFromContext: aContext ] on: Error do: [ :e | #(  ) ]
