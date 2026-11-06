tools
sessionOn: aProcess in: aReifiedMemory

	"A post mortem session on that process's stack, from its newest activation: `on: nil`, there
	being no process to resume. Frames answer as contexts, those on the VM's stack pages too (#150)."

	^ (ReifiedDebugSession
		   named: 'Polyphemus'
		   on: nil
		   startedAt: (aReifiedMemory activationsOfProcess: aProcess) first
		   fixing: nil)
		  stoppedBy: PolyphemusStop readFromMemory;
		  yourself
