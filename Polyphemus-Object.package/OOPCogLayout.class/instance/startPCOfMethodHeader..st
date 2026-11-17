reading
startPCOfMethodHeader: aMethodHeader

	"The bytecode pc a method with that header starts at, as the interpreter counts it."

	^ memory interpreter startPCOfMethodHeader: aMethodHeader