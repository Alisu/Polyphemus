reading
bytecodePCOf: aMachineCodePC inCogMethodAt: aCogMethodAddress

	"Cogit>>bytecodePCFor:startBcpc:in:, zero-relative, through that CogMethod's map. nil unless
	the pc is in that CogMethod and maps."

	| cogMethod start bytecodePC theCogit |
	theCogit := self cogit.
	cogMethod := theCogit cogMethodSurrogateAt: aCogMethodAddress.
	(aMachineCodePC between: cogMethod asUnsignedInteger and: cogMethod asUnsignedInteger + cogMethod blockSize)
		ifFalse: [ ^ nil ].
	start := memory interpreter startPCOfMethodHeader: cogMethod methodHeader.
	bytecodePC := ForeignCode
		              askingVMMaker: [ theCogit bytecodePCFor: aMachineCodePC startBcpc: start in: cogMethod ]
		              ifItFails: [ ^ nil ].
	^ bytecodePC = 0 ifFalse: [ bytecodePC ]
