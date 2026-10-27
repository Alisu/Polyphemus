holding it still
stop

	"Stopped so that a read is consistent, what was read before forgotten: running, it may have
	changed its map and its memory since (#102). Answers whether it stopped."

	self forgetWhatWasRead.
	^ self stopItsThreads
