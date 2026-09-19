reading
cogit

	"VMMaker's Cogit as the Pharo VM is built (StackToRegisterMappingCogit, SistaV1, x64),
	reading the dump, for its map from machine code pcs to bytecode pcs. Initializing its
	class sets only Cog's own pools, which the StackInterpreter does not use."

	^ cogit ifNil: [
		  (Cogit classPool at: #AnnotationShift) ifNil: [
			  StackToRegisterMappingCogit initializeWithOptions: (Dictionary newFrom: {
					   (#ObjectMemory -> #Spur64BitCoMemoryManager).
					   (#bytecodeTableInitializer -> #initializeBytecodeTableForSistaV1).
					   (#ISA -> #X64).
					   (#MULTIPLEBYTECODESETS -> true) }) ].
		  cogit := StackToRegisterMappingCogit basicNew.
		  cogit
			  instVarNamed: #objectMemory
			  put: (OOPCogCodeMemory on: raw objectMemory: memory interpreter objectMemory).
		  cogit
			  instVarNamed: #coInterpreter
			  put: (OOPCogInterpreterStandIn on: self interpreter: memory interpreter).
		  cogit instVarNamed: #backEnd put: CogInLineLiteralsX64Compiler basicNew.
		  cogit instVarNamed: #generatorTable put: StackToRegisterMappingCogit generatorTable.
		  cogit instVarNamed: #cogMethodSurrogateClass put: CogMethodSurrogate64.
		  cogit instVarNamed: #cogBlockMethodSurrogateClass put: CogBlockMethodSurrogate64.
		  cogit ]
