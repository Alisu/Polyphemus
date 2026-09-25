tools
debugDeepestProcessIn: aReifiedMemory

	"The real Pharo debugger, post mortem, on the deepest stack in the memory."

	^ StDebugger
		  openOn: (self sessionOnDeepestProcessIn: aReifiedMemory)
		  withFullView: true
