reading
machineCodePCOf: aMachineCodePC frame: aFramePointer

	"A machine code frame's pc as a context's, through Cog's map in its CogMethod
	(Cogit>>bytecodePCFor:startBcpc:in:). nil unless the pc is in that CogMethod and maps."

	| cogMethod start bytecodePC |
	cogMethod := self cogit cogMethodSurrogateAt: (self cogMethodOf: aFramePointer).
	(aMachineCodePC between: cogMethod asUnsignedInteger and: cogMethod asUnsignedInteger + cogMethod blockSize)
		ifFalse: [ ^ nil ].
	start := memory interpreter startPCOfMethodHeader: cogMethod methodHeader.
	bytecodePC := [ self cogit bytecodePCFor: aMachineCodePC startBcpc: start in: cogMethod ]
		              on: Error
		              do: [ :e | ^ nil ].
	^ bytecodePC = 0 ifTrue: [ nil ] ifFalse: [ bytecodePC + 1 ]
