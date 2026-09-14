context protocol
stackp

	| slot |
	slot := self reifiedSlotAt: memory contextStackPointerSlot.
	^ slot isNilOop ifTrue: [ 0 ] ifFalse: [ slot asInteger ]
