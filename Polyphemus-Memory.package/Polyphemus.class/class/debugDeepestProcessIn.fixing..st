tools
debugDeepestProcessIn: aReifiedMemory fixing: aMethodFix

	"The real Pharo debugger on the deepest stack in the memory, with its code pane able to
	write back: accepting there compiles here and installs in the image being read."

	| contexts |
	contexts := aReifiedMemory contextsOfProcess:
		            (self deepestProcessIn: aReifiedMemory).
	^ StDebugger
		  openOn: (ReifiedDebugSession
				   named: 'Polyphemus'
				   on: nil
				   startedAt: contexts first
				   fixing: aMethodFix)
		  withFullView: true
