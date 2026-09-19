running
frameOf: aMemory described: aDescription

	^ (aMemory allReifiedProcesses
		   inject: OrderedCollection new
		   into: [ :all :each | all addAll: (aMemory contextsOfProcess: each); yourself ])
		  detect: [ :each | (aMemory descriptionOfContext: each) = aDescription ]
