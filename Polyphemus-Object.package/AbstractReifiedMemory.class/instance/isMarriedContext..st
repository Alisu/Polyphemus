contexts
isMarriedContext: aContextOop

	"Whether the sender slot holds a frame pointer, a small integer, rather than a sender:
	the context is married to a frame. False for anything that is not a context."

	([ aContextOop isContextOop ] on: Error do: [ :e | false ]) ifFalse: [ ^ false ].
	^ (aContextOop reifiedSlotAt: self contextSenderSlot) isImmediateOop
