context protocol
compiledCode

	"The method or block it runs. A slot holding what is neither is refused by name (#196)."

	| code |
	code := self reifiedSlotAt: memory stacks contextMethodSlot.
	(code isCompiledMethodOop or: [ code isCompiledBlockOop ]) ifFalse: [
		^ NotInTheReading signal: 'the method of the context at ' , (address printStringRadix: 16)
			  , ' is no compiled code: ' , code whatItReadsAs ].
	^ code
