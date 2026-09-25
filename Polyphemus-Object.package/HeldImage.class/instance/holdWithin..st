holding
holdWithin: aDuration

	"Interrupt the image and hold it, with what it is busy with -- the process running when it
	was stopped to be interrupted -- in its own debugger. Refused by name without a watcher."

	| hash |
	self forget: #( 'interrupted' 'released' ).
	hash := reader whileStopped: [
		        reader
			        storeWord: 1
			        at: ((VMVariables on: reader) addressOf: 'interruptPending').
		        self activeProcessHash ].
	(self waitFor: 'interrupted' within: aDuration) ifFalse: [
		reader close.
		^ self error: 'the image never took the interrupt: is it running the watcher on '
			  , directory fullName , '?' ].
	self serveAndHold: hash startingAt: nil
