interpreter protocol
startPCOfMethod: aMethodOop

	^ interpreter startPCOfMethodHeader: (layout methodHeaderOf: aMethodOop)
