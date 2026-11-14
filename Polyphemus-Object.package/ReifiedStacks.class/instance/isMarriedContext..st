contexts
isMarriedContext: aContextOop

	"Whether the sender slot holds a frame pointer, a small integer, rather than a sender: the
	context is married to a frame. False for what is no context, and for a sender that does
	not read: a word that is no address of anything is no small integer either (#196)."

	aContextOop isContextOop ifFalse: [ ^ false ].
	^ (memory readSlot: self contextSenderSlot of: aContextOop ifUnreadable: [ ^ false ]) isImmediateOop
