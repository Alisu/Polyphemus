reading
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame to the oldest. Its own resumes
	at the ip on top of its page's stack when it is the page's head, else where the frame above saved it (#215)."

	| fp page frames |
	fp := (self framePointerOf: aContext) ifNil: [ ^ #(  ) ].
	page := [ raw vmVariables pageWithHeadFP: fp ] on: SpurCannotRead do: [ :unsaid | nil ].
	(self framesOfTheActivePageFrom: fp) ifNotNil: [ :active | ^ active ].
	frames := self framesFrom: fp stackTop: (page ifNotNil: [ page headSP ]).
	page ifNotNil: [
		frames first setSavedIP: (self wordAt: page headSP).
		^ frames ].
	(self savedIPOfTheFrameAbove: fp) ifNotNil: [ :ip | frames first setSavedIP: ip ].
	^ frames
