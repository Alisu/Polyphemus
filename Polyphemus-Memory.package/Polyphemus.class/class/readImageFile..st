reading
readImageFile: aPath

	"An image file opened in the simulator and not started: started, its running process would
	be married to a frame and read one frame deep. Refused below #readabilityOfImageFile:'s rungs."

	| readability |
	readability := self readabilityOfImageFile: aPath.
	#( #bytes #heap #objects #classes ) do: [ :each | readability require: each ].
	^ FullyReifiedMemory on: (self interpreterOnImageFile: aPath) objectMemory
