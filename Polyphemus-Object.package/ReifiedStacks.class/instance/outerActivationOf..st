contexts
outerActivationOf: aClosureOrNil

	"The activation a closure was made in: its outer context, or that context's frame when it is
	married, whose slots the VM does not keep. nil for none, or a frame we cannot find (#184)."

	| outer |
	aClosureOrNil ifNil: [ ^ nil ].
	outer := [ aClosureOrNil reifiedSlotAt: self closureOuterContextSlot ] on: Error do: [ :e | ^ nil ].
	outer isNilOop ifTrue: [ ^ nil ].
	(self isMarriedContext: outer) ifFalse: [ ^ outer ].
	^ (self framesFromContext: outer) ifEmpty: [ nil ] ifNotEmpty: [ :frames | frames first ]