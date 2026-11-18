tests
testAReadingForgottenKeepsNoDumpedMemory

	"#110, #211: a context Pharo's debugger keeps holds its reading, which forgot the memory it read
	but not the dumped memory it lists by: the copy of a held image stayed, hold after hold."

	| reading |
	reading := dumped reifiedMemory.
	self assert: (reading instVarNamed: #whole) notNil.
	reading forget.
	self assert: (reading instVarNamed: #whole) isNil
