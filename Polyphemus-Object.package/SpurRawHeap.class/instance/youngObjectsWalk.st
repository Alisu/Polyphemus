young objects
youngObjectsWalk

	"What walking new space by shape finds, or nil. It stops where the live objects stop,
	which a dump gives no other way of knowing."

	^ self youngSpaceStart ifNotNil: [ :start |
		  self scanner walkFrom: start upTo: self heapStart ]
