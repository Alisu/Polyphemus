writing
bereave: anOop

	"Whether this was a context naming a frame, in which case it names none."

	| scanner |
	scanner := dumped raw scanner.
	(((scanner headerAt: anOop) bitAnd: 16r3FFFFF) = self classIndexOfContexts and: [
		 dumped memory isIntegerObject: (scanner slotOf: anOop at: 1) ]) ifFalse: [ ^ false ].
	dumped memory
		storePointerUnchecked: 0
		ofObject: anOop
		withValue: dumped memory nilObject.
	^ true
