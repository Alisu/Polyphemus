writing
bereave: anOop

	"Whether this was a context naming a frame, in which case it names none. Read from the
	memory and not from the dump's bytes: the contexts divorced here hold senders the dump
	never held."

	| memory |
	memory := dumped memory.
	((memory classIndexOf: anOop) = self classIndexOfContexts and: [
		 memory isIntegerObject: (memory fetchPointer: 0 ofObject: anOop) ]) ifFalse: [ ^ false ].
	memory storePointerUnchecked: 0 ofObject: anOop withValue: memory nilObject.
	^ true
