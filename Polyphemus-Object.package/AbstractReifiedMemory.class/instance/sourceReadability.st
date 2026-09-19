source
sourceReadability

	"Whether this memory's methods read as their source (SourceReadability). Worked out once
	per reading of the graph."

	^ self rememberedAt: 'sourceReadability' ifAbsentPut: [ SourceReadability of: self ]
