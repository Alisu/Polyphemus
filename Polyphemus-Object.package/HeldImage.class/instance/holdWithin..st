holding
holdWithin: aDuration

	"Interrupt the image and hold it, with what it is busy with -- the process running when it
	was stopped to be interrupted -- in its own debugger. Refused by name without a watcher, and
	let go again when its Pharo is not one the edition reads."

	| hash |
	self forget: #( 'interrupted' 'released' ).
	hash := reader whileStopped: [
		        (SpurWritableProcess on: reader) signalExternalSemaphore: self semaphoreIndex.
		        self activeProcessHash ].
	(self waitFor: 'interrupted' within: aDuration) ifFalse: [
		reader close.
		^ self error: 'the image never took the interrupt: is it running the watcher on '
			  , directory fullName , '?' ].
	self serveAndHold: hash startingAt: nil.
	self checkItsVersion
