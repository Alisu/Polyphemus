stepping
step: aSelector below: aDepth

	"The image's debugger steps (stepInto:, stepOver: or stepThrough:) the context aDepth frames
	below the one it is at: counted, since a context has no name both sides share."

	channel ask: '| context |
context := (self at: #session) interruptedContext.
' , aDepth printString , ' timesRepeat: [ context := context sender ].
(self at: #session) ' , aSelector , ' context. nil'
