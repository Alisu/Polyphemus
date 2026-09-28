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
		  cogit instVarNamed: #cogMethodSurrogateClass put: self cogMethodSurrogateClass.
		  "VMMaker v10.3 has no block surrogate: its block methods read as methods."
		  (self class environment at: #CogBlockMethodSurrogate64 ifAbsent: [ nil ]) ifNotNil: [
			  :blockSurrogate |
			  cogit instVarNamed: #cogBlockMethodSurrogateClass put: blockSurrogate ].
		  "Where the running VM's methods and blocks start their code: set as its JIT generated it,
		  never by a simulated Cogit. VMMaker v12 walks a method's map from them."
		  #( 'cmEntryOffset' 'cmNoCheckEntryOffset' 'cbEntryOffset' 'cbNoSwitchEntryOffset' ) do: [
			  :each |
			  (cogit class allInstVarNames includes: each) ifTrue: [
				  [ cogit instVarNamed: each put: (raw vmVariables at: each) ]
					  on: Error
					  do: [ :e | nil ] ] ].
		  cogit ]
