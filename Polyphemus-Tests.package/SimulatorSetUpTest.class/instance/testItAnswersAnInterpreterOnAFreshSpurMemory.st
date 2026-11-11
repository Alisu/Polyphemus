tests
testItAnswersAnInterpreterOnAFreshSpurMemory

	"#118: VMMaker was set up twice, word for word, for a reading and for a dump; once now."

	| interpreter |
	interpreter := SimulatorSetUp newInterpreter.
	self assert: (interpreter isKindOf: StackInterpreterSimulatorLSB).
	self assert: interpreter objectMemory class equals: Spur64BitMemoryManager simulatorClass.
	self assert: interpreter objectMemory wordSize equals: 8
