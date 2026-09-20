writing
voidTheInterpretersRegisters

	"A collection maps the interpreter's own registers (#mapVMRegisters), and a dump-built
	one has none: they are voided here as a VM voids them for a snapshot."

	| interpreter nilOop |
	interpreter := dumped interpreter.
	nilOop := dumped memory nilObject.
	interpreter
		instVarNamed: #method put: nilOop;
		instVarNamed: #newMethod put: nilOop;
		instVarNamed: #instructionPointer put: 0;
		instVarNamed: #tempOop put: 0;
		instVarNamed: #tempOop2 put: 0;
		instVarNamed: #profileProcess put: nilOop;
		instVarNamed: #profileMethod put: nilOop;
		instVarNamed: #profileSemaphore put: nilOop
