context protocol
pc

	| slot |
	slot := self reifiedSlotAt: memory contextPcSlot.
	^ slot isNilOop ifTrue: [ nil ] ifFalse: [ slot asInteger ]
