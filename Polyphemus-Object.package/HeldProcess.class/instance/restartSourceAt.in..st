private
restartSourceAt: aDepth in: aMethodName

	"For the image: the frame aDepth below its debugger's, or the method it is a block of, restarted in
	the method named so, as Pharo's debugger does after a save (rewindContextToMethod:fromContext:)."

	^ '| context |
context := (self at: #session) interruptedContext.
' , aDepth printString , ' timesRepeat: [ context := context sender ].
(self at: #session) rewindContextToMethod: ' , aMethodName , ' fromContext: context home.
' , self keepStillSource , 'nil'
