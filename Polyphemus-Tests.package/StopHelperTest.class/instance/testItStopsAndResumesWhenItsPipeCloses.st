tests
testItStopsAndResumesWhenItsPipeCloses

	"#137: closing the pipe is the observer's resume, and it lasted when nothing ended it early."

	| stop |
	stop := StopHelper on: target in: directory.
	self assert: stop start.
	self assert: self isStopped.
	self assert: stop end.
	self deny: self isStopped
