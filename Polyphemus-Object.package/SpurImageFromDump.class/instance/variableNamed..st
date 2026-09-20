writing
variableNamed: aName

	"A variable of the dumped VM, or 0 where it cannot be read."

	^ [ dumped raw vmVariables at: aName ] on: Error do: [ :e | 0 ]
