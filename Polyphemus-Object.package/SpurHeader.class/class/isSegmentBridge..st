reading
isSegmentBridge: aHeader

	"A segment bridge's, as VMMaker writes one: class index 3 (its pun), word indexable."

	^ (self classIndexOf: aHeader) = 3 and: [ (self formatOf: aHeader) = 9 ]
