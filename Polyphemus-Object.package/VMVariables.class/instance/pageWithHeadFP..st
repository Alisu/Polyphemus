accessing
pageWithHeadFP: aFramePointer

	"The page in use whose newest frame is aFramePointer, or nil."

	^ self stackPages
		  detect: [ :each | each baseFP ~= 0 and: [ each headFP = aFramePointer ] ]
		  ifNone: [ nil ]
