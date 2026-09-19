contexts
isMarriedContext: aContextOop

	"Whether the sender slot holds a frame pointer, a small integer, rather than a sender:
	the context is married to a frame."

	^ (aContextOop reifiedSlotAt: self contextSenderSlot) isImmediateOop
