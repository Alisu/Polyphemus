accessing
instructionPointer

	"The byte this frame is about to execute: the interpreter's register for the active
	frame, the saved IP otherwise, or nil. Refused for a JIT frame unless its layout can map
	a machine code pc."

	(self isMachineCodeFrame and: [ self readsMachineCodePC not ]) ifTrue: [
		self signalMachineCode ].
	^ self isActiveFrame
		  ifTrue: [ [ memory interpreter instructionPointer ] on: Error do: [ :e | nil ] ]
		  ifFalse: [ savedIP ]
