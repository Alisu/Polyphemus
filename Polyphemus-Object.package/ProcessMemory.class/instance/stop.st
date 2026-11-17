holding it still
stop

	"Stopped so that a read is consistent, what was read before forgotten: running, it may have
	changed its map and its memory since (#102). Answers whether it stopped; a stop that did not
	take is taken back, or it could take with nobody there (#181)."

	self forgetWhatWasRead.
	^ self stopItsThreads or: [
		  self takeBackAStopThatDidNotTake.
		  false ]
