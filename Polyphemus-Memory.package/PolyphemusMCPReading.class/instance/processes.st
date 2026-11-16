reading
processes

	"Numbered by address, so a number stays the same process for the handle's life."

	^ processes ifNil: [
		  processes := (self reified allReifiedProcesses asSortedCollection: [ :a :b | a address <= b address ]) asArray ]
