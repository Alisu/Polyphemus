contexts
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame to the oldest. Empty
	when the context has no frame, as in every snapshot."

	([ self isMarriedContext: aContext ] on: Error do: [ :e | false ]) ifFalse: [
		^ #(  ) ].

	self livePages do: [ :page |
		| frames |
		frames := page frames.
		1 to: frames size do: [ :index |
			([ (frames at: index) oopContext = aContext ] on: Error do: [ :e | false ])
				ifTrue: [ ^ frames copyFrom: index to: frames size ] ] ].

	^ #(  )
