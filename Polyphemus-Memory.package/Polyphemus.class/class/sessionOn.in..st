tools
sessionOn: aProcess in: aReifiedMemory

	"A post mortem session on that process's stack: `on: nil`, there being no process to resume."

	^ (ReifiedDebugSession
		   named: 'Polyphemus'
		   on: nil
		   startedAt: (aReifiedMemory contextsOfProcess: aProcess) first
		   fixing: nil)
		  stoppedBy: PolyphemusStop readFromMemory;
		  yourself
