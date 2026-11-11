tests
testAnImageBusyAboveTheWatcherIsStoppedAsBeforeAfterItsTries

	"Nothing lower ever runs: the hold goes on as it did, and fails saying the watcher never ran."

	| image ran |
	image := self imageCatching: #( 80 ).
	ran := 0.
	self assert: (image whileStoppedOnAProcessItCanHold: [ ran := ran + 1. #held ]) equals: #held.
	self assert: ran equals: 1.
	self assert: image stops equals: image triesForAProcessItCanHold
