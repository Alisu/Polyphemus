contexts
frameOfContext: aContext

	"The frame a context is married to, or nil.

	Matched by asking each frame which context it is, rather than by decoding the frame
	pointer the context keeps in its sender slot. Both work; this one does not depend on
	our arithmetic being right about a number the image wrote."

	self livePages do: [ :page |
		page frames do: [ :frame |
			([ frame oopContext = aContext ] on: Error do: [ :e | false ]) ifTrue: [
				^ frame ] ] ].
	^ nil
