installing
pointAt: anOop insteadOf: aReifiedMethod in: aReifiedClass

	"Where the class keeps that method, found by looking for it rather than by knowing what a
	method dictionary looks like. The array is told it may now hold something younger."

	| methods index |
	methods := (aReifiedClass reifiedSlotAt: 2) reifiedSlotAt: 2.
	index := (methods allReifiedSlots collect: [ :each | each address ])
		         indexOf: aReifiedMethod address
		         ifAbsent: [ ^ CannotWriteThere signal: 'that class does not hold that method' ].
	memory remember: methods address.
	memory storePointer: index - 1 ofObject: methods address withValue: anOop.
	^ index
