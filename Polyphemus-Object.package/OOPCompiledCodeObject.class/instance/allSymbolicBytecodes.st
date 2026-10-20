decompile
allSymbolicBytecodes

	"Decoded through a view giving its literals as ours, which the printer can print (#100); each
	bytecode then names this code itself, not the view."

	| decoderClass |
	decoderClass := self class environment
		                at: #SymbolicBytecodeBuilder
		                ifAbsent: [ ^ self error: 'No method decoder class found' ].
	^ (decoderClass decode: (OOPDisassemblyView on: self))
		  do: [ :each | each method: self ];
		  yourself
