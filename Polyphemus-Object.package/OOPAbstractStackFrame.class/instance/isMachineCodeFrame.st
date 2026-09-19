testing
isMachineCodeFrame

	"Whether the method field points below the heap, at a CogMethod: the VM's own
	CoInterpreter>>isMachineCodeFrame:. False without a JIT."

	^ [
	  (memory interpreter stackPages longAt: self offsetForMethod)
	  < memory interpreter objectMemory startOfMemory ]
		  on: Error
		  do: [ :e | false ]
