running
withAHeaderDamagedAt: aFraction do: aBlock

	"aBlock given a dumped memory on a copy of the core's bytes, in which the header of the object
	that far through old space has a format no object has, that object's address, and the last's."

	| scanner addresses victim header copy |
	scanner := dumped raw scanner.
	addresses := OrderedCollection new.
	scanner
		walkFrom: dumped raw heapStart
		upTo: dumped raw mappingLimit
		atMost: nil
		liveDo: [ :address :itsHeader | addresses add: address ].
	victim := addresses at: ((addresses size * aFraction) truncated min: addresses size - 20).
	header := scanner headerAt: victim.
	copy := dumped raw bytes copy.
	self poke: ((header bitAnd: (16r1F bitShift: 24) bitInvert) bitOr: (6 bitShift: 24)) at: victim in: copy.
	^ aBlock
		  value: (SpurDumpedMemory
				   on: (ByteArrayAddressSpace on: copy at: dumped raw mappingStart)
				   from: dumped raw mappingStart
				   to: dumped raw mappingLimit)
		  value: victim
		  value: addresses last
