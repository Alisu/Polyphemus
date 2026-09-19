helpers
allFrames

	^ memory allReifiedProcesses
		  inject: OrderedCollection new
		  into: [ :all :process |
			  all
				  addAll: ((memory activationsOfProcess: process) select: [ :each | each isStackFrame ]);
				  yourself ]
