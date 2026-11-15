highlighting
rangeIn: aHostCode at: aPC of: anActivation

	"The source interval of the instruction at aPC of code compiled here, read through the
	tree it was compiled from; none where Pharo does not find it."

	| tree |
	tree := (self hostTreeOf: anActivation) ifNil: [ ^ 1 to: 0 ].
	^ ForeignCode
		  askingPharo: [ ((self nodeOf: aHostCode in: tree) sourceNodeForPC: aPC) debugHighlightRange ]
		  ifItFails: [ 1 to: 0 ]
