reading
callerContextOf: aBaseFramePointer

	"Up to VMMaker v10 the StackInterpreter keeps it where other frames keep their caller's saved
	ip (FoxCallerContext); v12's builds base frames as Cog does and defines no such offset."

	^ ((StackInterpreter bindingOf: #FoxCallerContext) ifNotNil: [ :binding | binding value ])
		  ifNil: [ self callerContextAboveArgumentsOf: aBaseFramePointer ]
		  ifNotNil: [ self wordAt: aBaseFramePointer + memory wordSize ]
