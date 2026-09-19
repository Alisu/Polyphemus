testing
refuseIfMachineCode

	"Raise SpurCannotRead for a JIT frame this frame's reader cannot lay out."

	self isReadable ifFalse: [ self signalMachineCode ]
