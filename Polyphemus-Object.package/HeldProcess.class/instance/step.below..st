stepping
step: aSelector below: aDepth

	"The image's debugger steps (stepInto:, stepOver: or stepThrough:) the context aDepth frames below
	the one it is at (counted: a context has no name both sides share); one a step queued, kept out."

	self call: #step with: { aSelector asSymbol. aDepth }
