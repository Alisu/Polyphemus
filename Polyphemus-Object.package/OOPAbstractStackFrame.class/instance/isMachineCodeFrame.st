testing
isMachineCodeFrame

	"Is this frame running machine code the JIT produced, rather than bytecodes?

	The VM's own test, and it needs nothing but an address comparison: a frame's method field
	holds a CompiledMethod when it is interpreted and a CogMethod when it is jitted, and
	CogMethods live in the code zone, which lies below the object heap. So a method field
	pointing below the start of memory means machine code
	(CoInterpreter>>isMachineCodeFrame:).

	Answers false on a VM without a JIT, where there is no code zone and every frame is
	interpreted -- which is every frame we have read so far, because the simulator we open
	images with is the stack interpreter."

	^ [
	  (memory interpreter stackPages longAt: self offsetForMethod)
	  < memory interpreter objectMemory startOfMemory ]
		  on: Error
		  do: [ :e | false ]
