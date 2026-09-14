updating
refreshProcesses

	processList items: (reifiedMemory allReifiedProcesses
			 asSortedCollection: [ :a :b |
				 (reifiedMemory contextsOfProcess: a) size
				 >= (reifiedMemory contextsOfProcess: b) size ]) asArray
