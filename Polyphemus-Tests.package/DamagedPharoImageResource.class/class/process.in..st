building
process: aDescription in: aReading

	"The process of aReading whose newest context is described so."

	^ aReading allReifiedProcesses detect: [ :each |
		  (aReading contextsOfProcess: each)
			  ifEmpty: [ false ]
			  ifNotEmpty: [ :contexts | (aReading descriptionOfContext: contexts first) = aDescription ] ]
