holding it still
takeBackAStopThatDidNotTake

	"What this host sent to stop it is undone: a signal not yet taken, threads suspended in part.
	Not where the stop helper stops: it takes back its own, and another's stop is not ours to undo."

	self usesTheStopHelper ifFalse: [ self resumeItsThreads ]
