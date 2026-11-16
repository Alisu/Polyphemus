contexts
sourceCodeOfContext: anActivation

	"What a debugger shows of a frame or a context: its method's source, or its bytecodes where
	the source does not read."

	^ (self sourceOfContext: anActivation) ifNil: [ self disassemblyOfContext: anActivation ]
