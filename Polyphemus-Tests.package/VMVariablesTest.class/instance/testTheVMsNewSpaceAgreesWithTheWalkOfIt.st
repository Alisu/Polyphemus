tests
testTheVMsNewSpaceAgreesWithTheWalkOfIt

	"New space's objects start where the VM keeps its survivors, past space -- the first thing
	in new space on VM 9 as it happened, after an empty survivor space on VM 10 -- and every
	object the walk by shape reports is below the mark the VM kept for past space's live end."

	| raw mark |
	raw := SpurRawHeap on: dump.
	mark := variables at: 'pastSpaceStart'.

	self assert: raw youngSpaceStart equals: (variables boundsOf: 'pastSpace') key.
	raw youngObjectsByShapeDo: [ :each | self assert: each < mark ]
