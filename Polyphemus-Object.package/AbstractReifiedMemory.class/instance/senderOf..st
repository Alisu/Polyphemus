contexts
senderOf: aContextOop

	"The caller of a context, or nil. A married context ends the walk here; #marriedContexts
	names them, so a stack cut short shows as such."

	(self isMarriedContext: aContextOop) ifTrue: [ ^ self reifiedNilObject ].
	^ aContextOop reifiedSlotAt: self contextSenderSlot
