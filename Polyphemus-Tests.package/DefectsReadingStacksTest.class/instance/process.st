running
process

	"The process that was snapshotting: nineteen contexts, methods and blocks."

	^ self memory allReifiedProcesses detect: [ :each |
		  (self memory contextsOfProcess: each)
			  ifEmpty: [ false ]
			  ifNotEmpty: [ :contexts | (self memory descriptionOfContext: contexts first) = 'Process>>resume' ] ]
