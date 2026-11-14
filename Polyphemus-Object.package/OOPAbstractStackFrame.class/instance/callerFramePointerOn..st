private
callerFramePointerOn: aPageOrNil

	"The frame pointer saved here, when it leads down its page: above this frame, aligned, and
	not past the base of the page where the page is known. Else nil, and why is kept (#198)."

	| saved |
	saved := self layout wordAt: framePointer.
	(saved isInteger and: [
		 saved > framePointer and: [
			 (saved bitAnd: memory wordSize - 1) = 0 and: [ aPageOrNil isNil or: [ saved <= aPageOrNil baseFP ] ] ] ])
		ifTrue: [ ^ saved ].
	whyNoCaller := saved = 0
		               ifTrue: [ #itsFramesDoNotEndAtTheBaseOfItsPage ]
		               ifFalse: [ #itsSavedFramePointerDoesNotLeadDownItsPage ].
	^ nil
