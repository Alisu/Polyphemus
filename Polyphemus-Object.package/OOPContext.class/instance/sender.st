context protocol
sender

	"The caller, or nil at the bottom of the stack and for a married context, which a snapshot
	should not contain anyway. A sender that is no context is refused by name (#196)."

	| caller |
	caller := memory stacks senderOf: self.
	caller isNilOop ifTrue: [ ^ nil ].
	caller isContextOop ifFalse: [
		^ NotInTheReading signal: 'the sender of the context at ' , (address printStringRadix: 16)
			  , ' is no context: ' , caller whatItReadsAs ].
	^ caller
