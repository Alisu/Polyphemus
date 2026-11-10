building the memory
piecesDo: aBlock

	"The stretches of memory, each readable in one piece: a dump's segments clipped to the
	mapping, or the whole mapping for bytes in hand."

	| segments |
	segments := space loadableSegments ifNil: [ ^ aBlock value: mappingStart value: mappingLimit ].
	((segments
		  select: [ :each |
			  each address < mappingLimit and: [
				  each address + each sizeInFile > mappingStart ] ])
		 asSortedCollection: [ :a :b | a address <= b address ]) do: [ :each |
		aBlock
			value: (each address max: mappingStart)
			value: (each address + each sizeInFile min: mappingLimit) ]
