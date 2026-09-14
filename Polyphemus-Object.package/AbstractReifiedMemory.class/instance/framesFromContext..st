contexts
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame down to the oldest one
	there. Answers nothing when the context has no frame, which is every context of a
	snapshot.

	Found in one pass. A page builds its frames afresh each time it is asked, so a frame
	from one call is not the same object as the one from the next, and looking for it by
	identity finds nothing. The context is the thing that stays put."

	([ self isMarriedContext: aContext ] on: Error do: [ :e | false ]) ifFalse: [
		^ #(  ) ].

	self livePages do: [ :page |
		| frames |
		frames := page frames.
		1 to: frames size do: [ :index |
			([ (frames at: index) oopContext = aContext ] on: Error do: [ :e | false ])
				ifTrue: [ ^ frames copyFrom: index to: frames size ] ] ].

	^ #(  )
