reading
readImageFile: aPath

	"An image file opened in the simulator and not started: started, its running process would
	be married to a frame and read one frame deep. Refused below #readabilityOfImageFile:'s rungs."

	^ FullyReifiedMemory on: (self checkedInterpreterOnImageFile: aPath) objectMemory
