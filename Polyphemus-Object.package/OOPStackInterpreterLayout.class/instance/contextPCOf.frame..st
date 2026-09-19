reading
contextPCOf: anInstructionPointer frame: aFramePointer

	^ [ memory integerValueOf:
		  (memory interpreter contextInstructionPointer: anInstructionPointer frame: aFramePointer) ]
		  on: Error
		  do: [ :e | nil ]
