tools
sessionOn: aProcess in: aReifiedMemory

	"A post mortem session on that process's stack: `on: nil`, there being no process to resume.
	A stack that ends at a context married to a frame of the VM's says so (#149)."

	| contexts session |
	contexts := aReifiedMemory contextsOfProcess: aProcess.
	session := (ReifiedDebugSession
		            named: 'Polyphemus'
		            on: nil
		            startedAt: contexts first
		            fixing: nil)
		           stoppedBy: PolyphemusStop readFromMemory;
		           yourself.
	(aReifiedMemory stacks isMarriedContext: contexts last) ifTrue: [
		session mark: 'Stack cut where the VM holds its frames: hold the image to see all of it' ].
	^ session
