young objects
newSpaceLimit

	"Where new space ends: its own mapping's end, or where old space starts."

	^ youngMappingLimit ifNil: [ self heapStart ]
