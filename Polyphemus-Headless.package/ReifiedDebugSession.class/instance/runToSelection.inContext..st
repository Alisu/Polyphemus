stepping
runToSelection: anInterval inContext: aContext

	"Steps over until the frame, known by its height since each step reads it anew, reaches the
	selection; the debugger is told once, at the end, not redrawn at every step."

	| height |
	held ifNil: [ ^ super runToSelection: anInterval inContext: aContext ].
	(self pcRangeForContext: aContext) first >= anInterval first ifTrue: [ ^ self ].
	height := self heightOf: aContext.
	held step: 'stepOver:' below: (self depthOf: aContext).
	self updateContextTo: held context.
	[
	(self heightOf: self interruptedContext) = height and: [
		(self pcRangeForContext: self interruptedContext) first < anInterval first ] ] whileTrue: [
		held step: 'stepOver:' below: 0.
		self updateContextTo: held context ].
	self triggerEvent: #stepOver
