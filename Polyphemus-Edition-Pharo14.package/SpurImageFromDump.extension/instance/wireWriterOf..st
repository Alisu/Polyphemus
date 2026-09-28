*Polyphemus-Edition-Pharo14
wireWriterOf: anInterpreter

	"VMMaker v10.3 writes through one reader-writer for both formats; we write Spur."

	anInterpreter instVarNamed: #imageReaderWriter put: ((VMImageReaderWriter
			  newWithMemory: dumped memory
			  andInterpreter: anInterpreter)
			 setFormatToUse: (VMImageReaderWriter classVariableNamed: #SpurFormatForced) value;
			 yourself)
