where
contexts

	"The process's stack from a new copy taken in one stop. Its frames live on stack pages, out of
	the heap we copy, so the image moves them into contexts first (voidCogVMState, which also
	discards machine code the image will make again)."

	channel ask: 'Smalltalk vm voidCogVMState. nil'.
	^ heldReading contextsOfTheProcess
