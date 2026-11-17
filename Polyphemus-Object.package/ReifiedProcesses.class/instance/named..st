accessing
named: aName

	"The process of that name; refused, with the names there are, when none is."

	^ self allReifiedProcesses
		  detect: [ :each | (self nameOf: each) = aName ]
		  ifNone: [
			  NotInTheReading signal: 'no process named ' , aName printString , ' here; there are: ' , (', ' join:
					   ((self allReifiedProcesses collect: [ :each | self nameOf: each ]) reject: [ :each | each isNil ])) ]