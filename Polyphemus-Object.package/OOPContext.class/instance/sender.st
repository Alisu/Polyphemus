context protocol
sender

	"The caller, or nil at the bottom of the stack. A context married to a frame has its frame's,
	and a married caller answers as its frame (#215); a sender that is no context is refused (#196)."

	| stacks frames caller |
	stacks := memory stacks.
	(stacks isMarriedContext: self) ifTrue: [
		frames := stacks framesFromContext: self.
		^ frames isEmpty ifFalse: [ frames first sender ] ].
	caller := stacks senderOf: self.
	caller isNilOop ifTrue: [ ^ nil ].
	caller isContextOop ifFalse: [
		^ NotInTheReading signal: 'the sender of the context at ' , (address printStringRadix: 16)
			  , ' is no context: ' , caller whatItReadsAs ].
	frames := stacks framesFromContext: caller.
	^ frames isEmpty ifTrue: [ caller ] ifFalse: [ frames first ]
