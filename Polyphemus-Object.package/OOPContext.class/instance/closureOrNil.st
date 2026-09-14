context protocol
closureOrNil

	| slot |
	slot := self reifiedSlotAt: memory contextClosureSlot.
	^ slot isNilOop ifTrue: [ nil ] ifFalse: [ slot ]
