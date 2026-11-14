contexts
outerActivationOf: aClosureOrNil

	"The activation a closure was made in: its outer context, or that context's frame when it is
	married, whose slots the VM does not keep. nil for none, or a frame we cannot find (#184);
	refused by name when the slot does not read or holds what is no context (#196)."

	| outer |
	aClosureOrNil ifNil: [ ^ nil ].
	outer := aClosureOrNil reifiedSlotAt: self closureOuterContextSlot.
	outer isNilOop ifTrue: [ ^ nil ].
	outer isContextOop ifFalse: [
		^ NotInTheReading signal: 'the closure at ' , (aClosureOrNil address printStringRadix: 16)
			  , ' keeps as its outer context what is no context: ' , outer printString ].
	(self isMarriedContext: outer) ifFalse: [ ^ outer ].
	^ (self framesFromContext: outer) ifEmpty: [ nil ] ifNotEmpty: [ :frames | frames first ]
