writing
variableNamed: aName

	"A variable of the dumped VM, refused when it does not read."

	^ self read: aName from: dumped raw vmVariables