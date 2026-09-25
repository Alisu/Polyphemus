where
topContextIn: aReading

	"The context the process is in, as a reading of the image shows it. The reading must hold
	every object, as Polyphemus class>>readProcess: gives one: a lazy one knows few processes."

	| process |
	process := aReading allReifiedProcesses
		           detect: [ :each | each oopHash = hash ]
		           ifNone: [ ^ self error: 'that reading does not hold the process; read it whole' ].
	^ (aReading contextsOfProcess: process) first
