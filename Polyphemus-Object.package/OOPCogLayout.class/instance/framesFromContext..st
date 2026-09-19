reading
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame to the oldest. When it
	is the head of its page, the VM's page record says where its stack ends, and the ip it
	will resume at is on top of that stack."

	| fp page frames |
	fp := (self framePointerOf: aContext) ifNil: [ ^ #(  ) ].
	page := [ raw vmVariables pageWithHeadFP: fp ] on: Error do: [ :e | nil ].
	frames := self framesFrom: fp stackTop: (page ifNotNil: [ page headSP ]).
	page ifNotNil: [ frames first setSavedIP: (self wordAt: page headSP) ].
	^ frames
