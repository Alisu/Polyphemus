context protocol
pc

	| slot |
	slot := self reifiedSlotAt: memory stacks contextPcSlot.
	^ slot isNilOop ifTrue: [ nil ] ifFalse: [ slot asInteger ]
