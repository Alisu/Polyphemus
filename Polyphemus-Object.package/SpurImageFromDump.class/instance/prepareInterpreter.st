writing
prepareInterpreter

	"What the header builder reads and a dump-built simulator never set: taken from the
	dumped VM's own variables, and a writer wired to its memory."

	| interpreter |
	interpreter := dumped interpreter.
	interpreter
		instVarNamed: #preemptionYields put: (self variableNamed: 'preemptionYields') ~= 0;
		instVarNamed: #imageHeaderFlags put: (self variableNamed: 'imageHeaderFlags');
		instVarNamed: #extraVMMemory put: (self variableNamed: 'extraVMMemory');
		instVarNamed: #imageWriter put: (SpurImageWriter new
				 interpreter: interpreter;
				 objectMemory: dumped memory;
				 segmentManager: dumped memory segmentManager;
				 yourself)
