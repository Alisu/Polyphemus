accessing
reifiedFrom: aDumpedMemory

	"Every object of the dump reified, once for the class: it takes about ten seconds, and the
	tests that use it only read."

	^ Reified ifNil: [ Reified := aDumpedMemory reifyEverything: aDumpedMemory reifiedMemory ]
