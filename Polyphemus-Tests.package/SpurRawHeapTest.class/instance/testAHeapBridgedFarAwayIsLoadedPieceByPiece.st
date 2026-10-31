tests
testAHeapBridgedFarAwayIsLoadedPieceByPiece

	"#133: a reading's simulator memory holds each piece at its own address and nothing for the
	gap between them, which a walk steps over by the bridge."

	| manager regions |
	manager := MachineSimulatorMemoryManager new wordSize: 8; yourself.
	(SpurDumpedMemory on: self copyOfAHeapBridgedFarAway) loadMappingInto: manager.
	regions := SortedCollection sortBlock: [ :a :b | a key <= b key ].
	manager regionsDo: [ :start :bytes | regions add: start -> bytes size ].
	self assert: regions asArray equals: { 16r10000000 -> 16r2000. 16r7FB741EF6000 -> 16r1000 }.
	self assert: ((manager unsignedLong64At: 16r10000000 + 16r2000 - 8) bitAnd: 16r3FFFFF) equals: 3
