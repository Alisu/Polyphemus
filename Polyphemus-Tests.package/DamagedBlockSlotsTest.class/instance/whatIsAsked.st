running
whatIsAsked

	"What a block is asked of its own header and literals, and its context of the method it is in."

	^ (#( #hostMethodOop #encoderClass #numTemps #numArgs #numberOfLiterals #allSymbolicBytecodes #allCompiledBlocks
	      #endPC #firstActivationPC #lastActivationPC #lastLiteral #allLiterals #methodHeader ) collect: [ :each |
		   each -> [ subject perform: each ] ])
	  , { ('homeMethod' -> [ context homeMethod ]) }
