tests
testAStopThatCatchesTheDelayTimerIsTakenAgain

	"#172: the timer at 80 runs on above the agent; held, its debugger was at a context long gone."

	| image ran |
	image := self imageCatching: #( 80 80 40 ).
	ran := 0.
	self assert: (image whileStoppedOnAProcessItCanHold: [ ran := ran + 1. #held ]) equals: #held.
	self assert: ran equals: 1.
	self assert: image stops equals: 3
