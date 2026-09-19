tests
testTheVMsNewSpaceAgreesWithTheWalkOfIt

	"New space starts where we found it by shape, and every object the walk by shape reported
	is below the mark the VM kept for the live end of past space."

	| raw mark |
	raw := StackOfADumpTest memory vmLayout raw.
	mark := variables at: 'pastSpaceStart'.

	self assert: (variables at: 'newSpaceStart') equals: raw youngSpaceStart.
	raw youngObjectsByShapeDo: [ :each | self assert: each < mark ]
