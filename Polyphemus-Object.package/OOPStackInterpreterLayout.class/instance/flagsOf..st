reading
flagsOf: aFramePointer

	| at |
	at := aFramePointer - (3 * memory wordSize).
	^ OOPStackFrameFlag
		  tag: (self wordAt: at)
		  numArgs: (self byteAt: at + 1)
		  hasContext: (self byteAt: at + 2) ~= 0
		  isBlockActivation: (self byteAt: at + 3) ~= 0
