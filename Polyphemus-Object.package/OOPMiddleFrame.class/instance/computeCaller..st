initialization
computeCaller: aCogStackPage

	"The frame below, where the saved frame pointer leads down the page to one."

	(self callerFramePointerOn: aCogStackPage) ifNotNil: [ :saved |
		caller := OOPAbstractStackFrame
			          newFrameBelow: self
			          starting: saved
			          from: aCogStackPage
			          on: memory ]
