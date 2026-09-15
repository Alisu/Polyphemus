contexts
findFrom: anActivation suchThat: aBlock

	"The first activation from this one down that answers the block, or nil."

	^ (self stackFrom: anActivation ofSize: 10000)
		  detect: aBlock
		  ifNone: [ nil ]
