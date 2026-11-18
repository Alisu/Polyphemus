tests
testAReadingForgottenKeepsNoLayoutOfTheMemoryItRead

	"#110: a forgotten reading kept its layout, and through it the bytes read and, once a machine
	code pc was mapped, VMMaker's Cogit over the simulator's memory: one run in eight on the box,
	the debugger done with a held image still held its simulator."

	| reading |
	reading := dumped reifiedMemory.
	self assert: ((reading instVarNamed: #vmLayout) isKindOf: OOPCogLayout).
	reading forget.
	self assert: (reading instVarNamed: #vmLayout) isNil
