contexts
senderOf: aContextOop

	"The caller of a context, or nil where the snapshot has none.

	Married contexts end the walk: their caller is a frame, and frames are stage two
	work. #marriedContexts names the ones we stopped at, so that a stack cut short is
	visible rather than silently short."

	(self isMarriedContext: aContextOop) ifTrue: [ ^ self reifiedNilObject ].
	^ aContextOop reifiedSlotAt: self contextSenderSlot
