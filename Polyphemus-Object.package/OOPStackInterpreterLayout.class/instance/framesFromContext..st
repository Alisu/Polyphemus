reading
framesFromContext: aContext

	"The frames of the live page this context runs on, from its own frame to the oldest."

	memory stacks livePages do: [ :page |
		| frames |
		frames := page frames.
		1 to: frames size do: [ :index |
			((frames at: index) hasContextThatIs: aContext) ifTrue: [ ^ frames copyFrom: index to: frames size ] ] ].
	^ #(  )
