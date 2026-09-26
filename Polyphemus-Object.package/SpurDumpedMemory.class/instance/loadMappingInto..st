building the memory
loadMappingInto: aManager

	"Copy the mapping into aManager at its original address, and new space's own mapping when
	it has one (VM 10). Nothing is relocated."

	self load: raw bytes at: raw mappingStart size: raw mappingLimit - raw mappingStart into: aManager.
	raw youngMappingStart ifNotNil: [ :start |
		self load: raw youngBytes at: start size: raw youngMappingLimit - start into: aManager ]
