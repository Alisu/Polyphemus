instance creation
named: aName because: aString on: aMemory

	"A value read by name, a class variable's, that does not read."

	^ self new
		  setName: aName reason: aString;
		  memory: aMemory;
		  yourself
