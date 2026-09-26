reading
contextPCOf: anInstructionPointer frame: aFramePointer

	"CoInterpreter>>contextInstructionPointer:frame:. A machine code frame's ip is mapped
	through Cog's map. For an interpreted one, ceReturnToInterpreter means the real ip is in
	the frame's saved ip, and any other code address is no bytecode."

	| ip name |
	(self isMachineCodeFrame: aFramePointer) ifTrue: [
		^ self machineCodePCOf: anInstructionPointer frame: aFramePointer ].
	ip := anInstructionPointer.
	(raw isMachineCodeAddress: ip) ifTrue: [
		name := self nameOfCodeAddress: ip.
		(name isNil or: [ name = 'ceReturnToInterpreterTrampoline' ]) ifFalse: [ ^ nil ].
		ip := self wordAt: aFramePointer - (4 * memory wordSize) ].
	^ ip - (self methodOf: aFramePointer) - memory wordSize + 2
