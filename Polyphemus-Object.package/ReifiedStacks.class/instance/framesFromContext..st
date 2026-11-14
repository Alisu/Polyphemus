contexts
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame to the oldest. Empty
	when the context has no frame, as in every snapshot, and where its frames are refused:
	#whyTheStackEndsAfter: says which."

	(self isMarriedContext: aContext) ifFalse: [ ^ #(  ) ].
	^ [ memory vmLayout framesFromContext: aContext ] on: PolyphemusError do: [ :e | #(  ) ]
