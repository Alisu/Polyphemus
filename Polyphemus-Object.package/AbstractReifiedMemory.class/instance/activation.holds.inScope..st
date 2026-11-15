naming
activation: anActivation holds: aVariable inScope: aScope

	"Does this activation hold the variable, or does it only see it? Seeing is not enough: an
	index means something only where the scope that declared it runs, and reading it anywhere
	else answers whatever happens to sit at that position."

	(self vectorHolding: aVariable inScope: aScope) ifNotNil: [ ^ true ].
	^ ForeignCode askingPharo: [ aVariable scope == aScope ] ifItFails: [ false ]
