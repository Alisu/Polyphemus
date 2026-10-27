highlighting
rangeIn: aHostCode at: aPC of: anActivation

	"The source interval of the instruction at aPC of code compiled here, read through the
	tree it was compiled from."

	^ [
	  ((self nodeOf: aHostCode in: (self hostTreeOf: anActivation)) sourceNodeForPC: aPC)
		  debugHighlightRange ]
		  on: Error
		  do: [ :e | 1 to: 0 ]
