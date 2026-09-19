contexts
frameOfContext: aContext

	"The frame a context is married to, or nil: found by asking each frame for its context, not
	by decoding the frame pointer the context holds."

	self livePages do: [ :page |
		page frames do: [ :frame |
			([ frame oopContext = aContext ] on: Error do: [ :e | false ]) ifTrue: [
				^ frame ] ] ].
	^ nil
