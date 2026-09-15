accessing
segmentHolding: anAddress

	"The segment whose bytes cover this address, or nil. A region that was dumped only in
	part does not hold the addresses past what was written of it."

	^ self loadableSegments
		  detect: [ :each | each holdsAddress: anAddress ]
		  ifNone: [ nil ]
