settings
requestLimit

	"How long a held image runs one request before its agent stops it and says so (#161): under
	the minute an observer waits for an answer, so that the answer comes."

	^ RequestLimit ifNil: [ 50 seconds ]
