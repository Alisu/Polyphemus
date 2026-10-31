building the memory
loadMappingInto: aManager

	"Copy the mapping into aManager at its original address, a region per piece and none for the
	gaps bridges span (#133), and new space's own mapping when it has one (VM 10). Nothing is relocated."

	raw pieces do: [ :each | self load: each bytes at: each baseAddress size: each size into: aManager ].
	raw youngMappingStart ifNotNil: [ :start |
		self load: raw youngBytes at: start size: raw youngMappingLimit - start into: aManager ]
