private
callerFramePointerOn: somePageBounds

	"The frame pointer saved here, when it leads down its page: above this frame, aligned, and
	within the page's bounds. Else nil, and why is kept (#198)."

	| saved |
	saved := [ self layout wordAt: framePointer ] on: NotInTheReading do: [ :refusal |
		         whyNoCaller := #itsSavedFramePointerIsNotInThisMemory.
		         ^ nil ].
	(saved > framePointer and: [
		 (saved bitAnd: memory wordSize - 1) = 0 and: [ somePageBounds holds: saved ] ]) ifTrue: [ ^ saved ].
	whyNoCaller := saved = 0
		               ifTrue: [ #itsFramesDoNotEndAtTheBaseOfItsPage ]
		               ifFalse: [ #itsSavedFramePointerDoesNotLeadDownItsPage ].
	^ nil
