reading
slotOf: anOop named: aClassName

	0 to: (objectMemory numSlotsOf: anOop) - 1 do: [ :i |
		| each |
		each := objectMemory fetchPointer: i ofObject: anOop.
		(self is: each named: aClassName) ifTrue: [ ^ each ] ].
	^ nil
