*Polyphemus-Edition-Pharo10
wireWriterOf: anInterpreter

	"VMMaker v10.0 writes through a Spur writer of its own."

	anInterpreter instVarNamed: #imageWriter put: (SpurImageWriter new
			 interpreter: anInterpreter;
			 objectMemory: dumped memory;
			 segmentManager: dumped memory segmentManager;
			 yourself)
