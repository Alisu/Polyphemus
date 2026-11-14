accessing
oopReceiver

	"The object it runs in. Refused for a JIT frame this layout cannot read, and by name for a
	field that holds no object (#198)."

	self refuseIfMachineCode.
	^ receiver ifNil: [ self refuseItsField: 'receiver' holding: (self layout receiverOf: framePointer) ]
