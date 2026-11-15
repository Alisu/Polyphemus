reading
machineCodePCOf: aMachineCodePC frame: aFramePointer

	"A machine code frame's pc as a context's, through Cog's map in its CogMethod
	(Cogit>>bytecodePCFor:startBcpc:in:). nil unless the pc is in that CogMethod and maps;
	refused by name where the frame's method field is no CogMethod."

	| cogMethod start bytecodePC theCogit |
	(raw isMachineCodeAddress: (self cogMethodOf: aFramePointer)) ifFalse: [
		^ self refuse: #itsMethodFieldIsNoCogMethod ].
	cogMethod := self cogit cogMethodSurrogateAt: (self cogMethodOf: aFramePointer).
	(aMachineCodePC between: cogMethod asUnsignedInteger and: cogMethod asUnsignedInteger + cogMethod blockSize)
		ifFalse: [ ^ nil ].
	start := memory interpreter startPCOfMethodHeader: cogMethod methodHeader.
	theCogit := self cogit.
	bytecodePC := ForeignCode
		              askingVMMaker: [ theCogit bytecodePCFor: aMachineCodePC startBcpc: start in: cogMethod ]
		              ifItFails: [ ^ nil ].
	^ bytecodePC = 0 ifTrue: [ nil ] ifFalse: [ bytecodePC + 1 ]
