source
sourceServing: aDirectory bell: aSource

	"The agent, ending itself after the hold limit without a request."

	^ self sourceServing: aDirectory bell: aSource limit: self holdLimit
