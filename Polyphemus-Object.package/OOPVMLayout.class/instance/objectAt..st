reading
objectAt: aWord

	"What a frame's word refers to: an immediate as a slot gives it, the reified object at that
	address, or nil for a word that is neither."

	(memory isImmediate: aWord) ifTrue: [ ^ memory reifyOop: aWord ].
	^ memory objectAt: aWord
