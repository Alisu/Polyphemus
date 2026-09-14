context protocol
holds: aVariable inScope: aScope

	"Does this frame hold the variable, or does it only see it? Seeing is not enough: an
	index means something only in the frame whose scope declared it, and reading it
	anywhere else answers whatever happens to sit at that position."

	(self vectorHolding: aVariable inScope: aScope) ifNotNil: [ ^ true ].
	^ [ aVariable scope == aScope ] on: Error do: [ :e | false ]
