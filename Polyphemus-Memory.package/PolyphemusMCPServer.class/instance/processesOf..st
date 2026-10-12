tools
processesOf: anImage

	"Numbered by address, so a number stays the same process for the handle's life."

	^ anImage at: #processes ifAbsentPut: [
		  ((self reifiedOf: anImage) allReifiedProcesses asSortedCollection: [ :a :b | a address <= b address ]) asArray ]
