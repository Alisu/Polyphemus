accessing
oopMethod

	"The compiled method or block it runs. Refused for a JIT frame this layout cannot read, and
	by name for a field that holds no compiled code (#198)."

	self refuseIfMachineCode.
	method ifNil: [ ^ self refuseItsField: 'method' holding: (self layout methodOf: framePointer) ].
	(method isCompiledMethodOop or: [ method isCompiledBlockOop ]) ifFalse: [
		^ NotInTheReading signal: 'the method of the frame at ' , (framePointer printStringRadix: 16)
			  , ' is no compiled code: ' , method whatItReadsAs ].
	^ method
