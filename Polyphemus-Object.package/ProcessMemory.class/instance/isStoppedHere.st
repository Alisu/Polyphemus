holding it still
isStoppedHere

	"Stopped by this reader, so a stop inside it reads on. Without the helper, any stop counts."

	^ stopHelper notNil or: [ self usesTheStopHelper not and: [ self isStopped ] ]
