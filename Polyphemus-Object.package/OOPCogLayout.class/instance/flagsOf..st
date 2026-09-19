reading
flagsOf: aFramePointer

	"A machine code frame keeps its flags in the low bits of its method field and its
	argument count in its CogMethod; an interpreted one has a flags word, as the simulator's."

	| field |
	(self isMachineCodeFrame: aFramePointer) ifTrue: [
		field := self wordAt: aFramePointer - memory wordSize.
		^ OOPStackFrameFlag
			  tag: field
			  numArgs: (self byteAt: (self cogMethodOf: aFramePointer) + memory wordSize)
			  hasContext: (field bitAnd: 1) ~= 0
			  isBlockActivation: (field bitAnd: 2) ~= 0 ].
	field := aFramePointer - (3 * memory wordSize).
	^ OOPStackFrameFlag
		  tag: (self wordAt: field)
		  numArgs: (self byteAt: field + 1)
		  hasContext: (self byteAt: field + 2) ~= 0
		  isBlockActivation: (self byteAt: field + 3) ~= 0
