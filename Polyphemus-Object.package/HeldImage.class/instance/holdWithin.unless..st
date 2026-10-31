holding
holdWithin: aDuration unless: aCondition

	"Hold it as holdWithin: does, unless aCondition, checked once the image is stopped, says it holds
	already (a trap that fired, #137); answers whether this did. The hold file says it is wanted."

	| hash held |
	held := false.
	hash := reader whileStopped: [
		        aCondition value ifFalse: [
			        held := true.
			        self forget: #( 'interrupted' 'released' ).
			        (directory / 'hold') ensureCreateFile.
			        (SpurWritableProcess on: reader) signalExternalSemaphore: self semaphoreIndex.
			        self activeProcessHash ] ].
	held ifFalse: [ ^ false ].
	(self waitFor: 'interrupted' within: aDuration) ifFalse: [
		reader close.
		^ self error: 'the image never took the interrupt: is it running the watcher on '
			  , directory fullName , '?' ].
	self serveAndHold: hash startingAt: nil.
	self checkItsVersion.
	^ true
