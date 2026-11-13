tools
sessionOn: aProcess in: aReifiedMemory

	"A post mortem session on that process's stack, from its newest activation: `on: nil`, there
	being no process to resume. Frames answer as contexts, those on stack pages too (#150, #183)."

	| stack |
	stack := aReifiedMemory activationsOfProcess: aProcess.
	stack ifEmpty: [ ^ NotInTheReading signal: 'that process has no activation to debug' ].
	^ (ReifiedDebugSession
		   named: 'Polyphemus'
		   on: nil
		   startedAt: stack first
		   fixing: nil)
		  stoppedBy: PolyphemusStop readFromMemory;
		  yourself