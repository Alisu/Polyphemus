running
framesOf: aProcess

	^ (memory activationsOfProcess: aProcess) select: [ :each | each isStackFrame ]
