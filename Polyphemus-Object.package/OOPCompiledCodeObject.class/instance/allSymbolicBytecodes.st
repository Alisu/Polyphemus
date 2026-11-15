decompile
allSymbolicBytecodes

	"Decoded by Pharo through a view giving its literals as ours (#100), read before Pharo is
	asked; each bytecode then names this code itself. Code Pharo cannot decode, a literal being
	no selector or variable where one is used, is refused by name (#206)."

	| decoderClass view |
	decoderClass := self class environment
		                at: #SymbolicBytecodeBuilder
		                ifAbsent: [ ^ NotSetUp signal: 'No method decoder class found' ].
	view := (OOPDisassemblyView on: self) readLiterals.
	^ (ForeignCode askingPharo: [ decoderClass decode: view ] ifItFails: [ :raised |
			   ^ NotInTheReading signal: 'the code at ' , (address printStringRadix: 16)
				     , ' does not disassemble: ' , raised messageText asString ])
		  do: [ :each | each method: self ];
		  yourself
