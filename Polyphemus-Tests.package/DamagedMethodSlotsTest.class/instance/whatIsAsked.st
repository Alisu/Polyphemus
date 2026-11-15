running
whatIsAsked

	"What a method is asked of its own header and literals."

	^ (#( #oopSelector #oopMethodClass #getSourceFromFile #sourceCode #numTemps #numArgs #numberOfLiterals
	     #allSymbolicBytecodes #allCompiledBlocks #endPC #firstActivationPC #lastActivationPC
	     #lastLiteral #penultimateLiteral #trailer #allLiterals ) collect: [ :each | each -> [ subject perform: each ] ])
	  , { ('oopPropertyAt:ifAbsent:' -> [ subject oopPropertyAt: #noSuchProperty ifAbsent: [ nil ] ]) }
