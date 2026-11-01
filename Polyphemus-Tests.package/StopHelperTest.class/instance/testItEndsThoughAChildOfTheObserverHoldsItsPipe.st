tests
testItEndsThoughAChildOfTheObserverHoldsItsPipe

	"#137 on macOS, where popen cannot keep the pipe from a child started meanwhile."

	| stop started |
	stop := StopHelper on: target in: directory.
	self assert: stop start.
	LibC system: 'sleep 20 > /dev/null 2>&1 &'.
	started := Time millisecondClockValue.
	self assert: stop end.
	self assert: Time millisecondClockValue - started < 5000.
	self deny: self isStopped
