reading
machineCodePCOf: aMachineCodePC frame: aFramePointer

	"A machine code frame's pc as a context's, through Cog's map in its CogMethod. nil unless the
	pc is in that CogMethod and maps; refused by name where the method field is no CogMethod."

	(raw isMachineCodeAddress: (self cogMethodOf: aFramePointer)) ifFalse: [
		^ self refuse: #itsMethodFieldIsNoCogMethod ].
	^ (self bytecodePCOf: aMachineCodePC inCogMethodAt: (self cogMethodOf: aFramePointer)) ifNotNil: [ :pc | pc + 1 ]
