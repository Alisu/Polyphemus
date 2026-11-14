instance creation
newFrameBelow: aStackFrame starting: anInteger from: somePageBounds on: aPreReifiedMemory

	"The frame the one above saved the frame pointer of, which makes those below it in turn."

	^ ((self shouldBeBaseFrame: anInteger from: somePageBounds on: aPreReifiedMemory)
		   ifTrue: [ OOPBaseFrame ]
		   ifFalse: [ OOPMiddleFrame ])
		  newFrameBelow: aStackFrame
		  starting: anInteger
		  from: somePageBounds
		  on: aPreReifiedMemory
