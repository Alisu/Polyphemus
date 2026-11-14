testing
isLastReadOfItsPage

	"The oldest frame of its page, or one whose saved frame pointer leads to no frame below (#198)."

	^ self isBaseFrame or: [ whyNoCaller notNil ]
