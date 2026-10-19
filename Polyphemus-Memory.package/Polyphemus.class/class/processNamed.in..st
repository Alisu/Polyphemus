tools
processNamed: aName in: aReifiedMemory

	"The process of that name in the memory; refused, with the names there are, when none is."

	^ aReifiedMemory allReifiedProcesses
		  detect: [ :each | (self nameOfProcess: each) = aName ]
		  ifNone: [
			  self error: 'no process named ' , aName printString , ' here; there are: ' , (', ' join:
					   ((aReifiedMemory allReifiedProcesses collect: [ :each | self nameOfProcess: each ])
						    reject: [ :each | each isNil ])) ]
