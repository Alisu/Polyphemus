reading
contextPCOf: anInstructionPointer frame: aFramePointer

	"CoInterpreter>>contextInstructionPointer:frame:. When the ip is ceReturnToInterpreter,
	the real one is in the frame's saved ip; any other code address is no bytecode. nil for
	machine code. Without the VM's variables, any ip below the heap is taken for the former."

	| ip name |
	(self isMachineCodeFrame: aFramePointer) ifTrue: [ ^ nil ].
	ip := anInstructionPointer.
	ip < raw mappingStart ifTrue: [
		name := self nameOfCodeAddress: ip.
		(name isNil or: [ name = 'ceReturnToInterpreterTrampoline' ]) ifFalse: [ ^ nil ].
		ip := self wordAt: aFramePointer - (4 * memory wordSize) ].
	^ ip - (self methodOf: aFramePointer) - memory wordSize + 2
