tests
testAClassVariableSaysWhetherItIsAPoolsWithoutAnErrorOfPharos

	"#118: Pharo's debugger asks a class variable whether it is a pool's, which asks the class that
	defines it. Ours named no class: '#isPool was sent to nil' at each debugger opened on a reading."

	| class variable |
	class := OOPClassWithAClassVariableThatDoesNotRead new.
	class address: 16r1000; memory: FullyReifiedMemory new.
	variable := class classVariableNamed: 'Limit'.
	(variable respondsTo: #isPoolVariable) ifFalse: [ ^ self skip: 'this Pharo asks a class variable no such thing' ].
	self deny: variable isPoolVariable
