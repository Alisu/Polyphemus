building the memory
piecesDo: aBlock

	"The stretches the memory is made of, each one readable in a single piece.

	For a dump those are its segments, clipped to what we are reading; for anything simpler
	-- bytes in hand -- it is one stretch. Nothing else here has to know the difference."

	(space respondsTo: #loadableSegments)
		ifFalse: [ ^ aBlock value: mappingStart value: mappingLimit ].
	((space loadableSegments
		  select: [ :each |
			  each address < mappingLimit and: [
				  each address + each sizeInFile > mappingStart ] ])
		 asSortedCollection: [ :a :b | a address <= b address ]) do: [ :each |
		aBlock
			value: (each address max: mappingStart)
			value: (each address + each sizeInFile min: mappingLimit) ]
