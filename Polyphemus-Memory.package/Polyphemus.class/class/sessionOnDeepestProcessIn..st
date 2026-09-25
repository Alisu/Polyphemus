tools
sessionOnDeepestProcessIn: aReifiedMemory

	"A post mortem session on the deepest stack: `on: nil`, there being no process to resume."

	^ (ReifiedDebugSession
		   named: 'Polyphemus'
		   on: nil
		   startedAt: (aReifiedMemory contextsOfProcess: (self deepestProcessIn: aReifiedMemory)) first
		   fixing: nil)
		  stoppedBy: PolyphemusStop readFromMemory;
		  yourself
