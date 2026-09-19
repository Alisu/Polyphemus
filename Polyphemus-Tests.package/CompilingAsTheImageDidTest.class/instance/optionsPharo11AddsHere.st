running
optionsPharo11AddsHere

	"The compiler defaults Pharo 11 turns on and Pharo 10 does not, as far as this host has them."

	^ #( optionCleanBlockClosure optionConstantBlockClosure optionInlineRepeat optionInlineTimesRepeat )
		  select: [ :each | CompilationContext respondsTo: each ]
