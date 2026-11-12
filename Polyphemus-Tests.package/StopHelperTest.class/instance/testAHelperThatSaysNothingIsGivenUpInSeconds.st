tests
testAHelperThatSaysNothingIsGivenUpInSeconds

	"One that never started writes no state: waited for as long as a stop may last, five minutes,
	the test that asked ran out of time (#31). Only another observer's stop is worth that wait."

	| silent helper started |
	silent := directory / 'silent-helper'.
	silent writeStreamDo: [ :stream | stream nextPutAll: '#!/bin/sh' , String lf , 'cat > /dev/null' , String lf ].
	LibC system: 'chmod +x ''' , silent fullName , ''''.
	helper := (StopHelper on: target in: directory bound: 60 seconds)
		          program: silent;
		          silenceLimit: 1 second;
		          yourself.
	started := DateAndTime now.
	self deny: helper start.
	self assert: DateAndTime now - started < 10 seconds.
	self deny: self isStopped
