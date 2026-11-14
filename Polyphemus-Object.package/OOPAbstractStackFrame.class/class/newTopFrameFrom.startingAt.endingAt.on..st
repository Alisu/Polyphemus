instanciation
newTopFrameFrom: somePageBounds startingAt: start endingAt: end on: aPreReifiedMemory

	"The newest frame of a page, which makes the frames below it, no further than the bounds."

	^ ((self shouldBeBaseFrame: start from: somePageBounds on: aPreReifiedMemory)
		   ifTrue: [ OOPBaseFrame ]
		   ifFalse: [ OOPTopFrame ]) newStart: start end: end from: somePageBounds on: aPreReifiedMemory
