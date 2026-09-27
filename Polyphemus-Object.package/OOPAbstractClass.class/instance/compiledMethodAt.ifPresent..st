as a compilation scope
compiledMethodAt: aSelector ifPresent: aBlock

	"Pharo 12's compiler asks for the method it replaces, to carry its properties over. A method
	of another image has none to give here."

	^ nil
