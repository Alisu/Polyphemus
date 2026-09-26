young objects
newSpaceStart

	"Where new space begins: its own mapping's start, or the heap mapping's."

	^ youngMappingStart ifNil: [ mappingStart ]
