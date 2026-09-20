helpers
classIndexOfContextsIn: aRawHeap

	"What a context's header says its class is: the class table index of the Context class,
	which the special objects array names and which is that class's own hash."

	| scanner contextClass |
	scanner := aRawHeap scanner.
	contextClass := scanner slotOf: aRawHeap specialObjectsOop at: 11.
	^ ((scanner headerAt: contextClass) bitShift: -32) bitAnd: 16r3FFFFF
