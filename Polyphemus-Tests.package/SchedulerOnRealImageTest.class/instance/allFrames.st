helpers
allFrames

	^ reifiedMemory allReifiedProcesses
		  inject: OrderedCollection new
		  into: [ :all :process |
			  all
				  addAll: (reifiedMemory contextsOfProcess: process);
				  yourself ]
