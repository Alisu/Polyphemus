walking
isSegmentBridgeHeader: aHeader

	"Whether this header is a segment bridge's, as VMMaker writes one: class index 3 (its pun),
	word indexable."

	^ (self classIndexIn: aHeader) = 3 and: [ (self formatIn: aHeader) = 9 ]
