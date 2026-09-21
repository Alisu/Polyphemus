installing
pointAt: anOop insteadOf: aReifiedMethod in: aReifiedClass

	"Where the class keeps that method, found by looking for it rather than by knowing what a
	method dictionary looks like. The array is told it may now hold something younger."

	| methods index |
	methods := (aReifiedClass reifiedSlotAt: 2) reifiedSlotAt: 2.
	index := (1 to: methods oopNumberOfSlots)
		         detect: [ :each |
			         [ (methods reifiedSlotAt: each) address = aReifiedMethod address ]
				         on: Error
				         do: [ :e | false ] ]
		         ifNone: [ ^ self error: 'that class does not hold that method' ].
	self remember: methods address.
	self slot: index - 1 of: methods address put: anOop.
	^ index
