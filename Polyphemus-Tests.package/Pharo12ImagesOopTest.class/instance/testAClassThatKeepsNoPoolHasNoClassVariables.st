tests
testAClassThatKeepsNoPoolHasNoClassVariables

	"#118: from Pharo 11 a class with no class variable keeps nil where its pool would be. Asking
	that nil for its array was an error, caught for each such class on each lookup of a name."

	| class |
	class := reifiedMemory oopClassNamed: 'Boolean'.

	self assert: (class oopSlotNamed: reifiedMemory mode classVariablesSlotName) isNilOop.
	self assert: class oopAllClassVariablesNames isEmpty.
	self assert: class oopAllClassVariables isEmpty.
	self assert: (class classVariableNamed: 'NoSuchVariable') isNil
