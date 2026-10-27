context protocol
closureOrNil

	| slot |
	slot := self reifiedSlotAt: memory stacks contextClosureSlot.
	^ slot isNilOop ifTrue: [ nil ] ifFalse: [ slot ]
