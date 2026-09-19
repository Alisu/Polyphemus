reading
isMachineCodeFrame: aFramePointer

	"CoInterpreter>>isMachineCodeFrame:: the method field points below the heap."

	^ [ (self wordAt: aFramePointer - memory wordSize)
	  < memory interpreter objectMemory startOfMemory ]
		  on: Error
		  do: [ :e | false ]
