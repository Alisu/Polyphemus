reading
savedIPOfTheFrameAbove: aFramePointer

	"Where a frame below the head of its page resumes: the ip the frame above saved for it, found
	from the head down (StackInterpreter>>findFrameAbove:inPage:); nil where none on its page calls it."

	| page above caller |
	page := [ self pageHolding: aFramePointer ] on: SpurCannotRead do: [ :unsaid | nil ].
	page ifNil: [ ^ nil ].
	above := page headFP.
	[ above < aFramePointer ] whileTrue: [
		caller := self wordAt: above.
		caller = aFramePointer ifTrue: [ ^ self wordAt: above + memory wordSize ].
		caller > above ifFalse: [ ^ nil ].
		above := caller ].
	^ nil
