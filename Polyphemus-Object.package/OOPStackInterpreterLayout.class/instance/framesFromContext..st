reading
framesFromContext: aContext

	"The frames of the live page this context runs on, from its own frame to the oldest."

	memory livePages do: [ :page |
		| frames |
		frames := page frames.
		1 to: frames size do: [ :index |
			([ (frames at: index) oopContext = aContext ] on: Error do: [ :e | false ])
				ifTrue: [ ^ frames copyFrom: index to: frames size ] ] ].
	^ #(  )
