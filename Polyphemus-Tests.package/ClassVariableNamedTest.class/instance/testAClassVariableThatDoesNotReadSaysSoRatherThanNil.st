tests
testAClassVariableThatDoesNotReadSaysSoRatherThanNil

	"#118: a class variable whose value did not read was answered as nil, which code evaluated
	in the debugger then took as a real nil. It stands as unreadable, naming itself and why."

	| class variable |
	class := OOPClassWithAClassVariableThatDoesNotRead new.
	class address: 16r1000; memory: FullyReifiedMemory new.
	variable := class classVariableNamed: 'Limit'.
	self assert: variable key equals: #Limit.
	self assert: variable value isUnreadableSlot.
	self deny: variable value isNilOop.
	self assert: (variable value printString includesSubstring: 'Limit').
	self assert: (variable value printString includesSubstring: 'its value points nowhere')
