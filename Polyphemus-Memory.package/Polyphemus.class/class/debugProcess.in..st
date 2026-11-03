tools
debugProcess: aProcess in: aReifiedMemory

	"The real Pharo debugger, post mortem, on that process's stack."

	^ StDebugger openOn: (self sessionOn: aProcess in: aReifiedMemory) withFullView: true
