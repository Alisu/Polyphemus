reading
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame to the oldest. When it
	is the head of its page, the VM's page record says where its stack ends, and the ip it
	will resume at is on top of that stack."

	| fp page frames current |
	fp := (self framePointerOf: aContext) ifNil: [ ^ #(  ) ].
	page := [ raw vmVariables pageWithHeadFP: fp ] on: Error do: [ :e | nil ].
	current := OOPAbstractStackFrame
		           newTopFrameFrom: nil
		           startingAt: fp
		           endingAt: (page ifNotNil: [ page headSP ])
		           on: memory.
	page ifNotNil: [ current setSavedIP: (self wordAt: page headSP) ].
	frames := OrderedCollection with: current.
	[ current isBaseFrame ] whileFalse: [
		current := current oopCaller.
		frames add: current ].
	^ frames
