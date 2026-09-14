context protocol
sender

	"The caller, or nil at the bottom of the stack. The memory knows how to read a
	married context, which a snapshot should not contain anyway."

	| caller |
	caller := memory senderOf: self.
	^ caller isNilOop ifTrue: [ nil ] ifFalse: [ caller ]
