tools
debugDeepestProcessIn: aReifiedMemory

	"The real Pharo debugger, post mortem, on the deepest stack in the memory. `on: nil` is
	what makes it post mortem: there is no process to resume, and the title says so."

	| contexts |
	contexts := aReifiedMemory contextsOfProcess:
		            (self deepestProcessIn: aReifiedMemory).
	^ StDebugger
		  openOn: (DebugSession named: 'Polyphemus' on: nil startedAt: contexts first)
		  withFullView: true
