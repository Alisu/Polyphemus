tests
testANewSpaceEndPastWhatIsHeldIsNotAllocatedFor

	"#182: the end of new space was taken as the VM states it, and youngBytes allocated up to it;
	a damaged one, a terabyte on, is refused, as a start not held already was."

	<readsAnUnsoundHeap>
	| stated regions variables raw |
	stated := ByteArray new: 16.
	stated integerAt: 1 put: 16r10000 size: 8 signed: false.
	stated integerAt: 9 put: 16r10000 + (1 bitShift: 40) size: 8 signed: false.
	regions := RegionsDouble new.
	regions region: 16r100000 bytes: (ByteArray new: 4096) writable: false.
	regions region: 16r10000 bytes: (ByteArray new: 4096) writable: false.
	regions region: 16r200000 bytes: stated writable: false.
	variables := VMVariablesDouble on: regions at: (Dictionary new
			              at: 'newSpaceStart' put: 16r200000;
			              at: 'newSpaceEnd' put: 16r200008;
			              yourself).
	raw := (SpurRawHeap on: regions from: 16r100000 to: 16r101000)
		       setVMVariables: variables;
		       findYoungMapping;
		       yourself.

	self assert: raw youngMappingStart isNil.
	self assert: raw youngBytes isNil