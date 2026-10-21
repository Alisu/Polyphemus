private
serveAndHold: aHash startingAt: aMethodSourceOrNil

	"With the watcher holding: hand it an agent on a fresh channel, let it serve, and put that
	process in the image's own debugger, read on from the last hold's reading when there was one."

	| channel ring previous |
	channel := DirectoryChannel on: directory / 'channel'.
	channel directory ensureDeleteAll.
	(directory / 'do.st')
		ensureDelete;
		writeStreamDo: [ :stream |
			stream nextPutAll: (PolyphemusAgent
					 sourceServing: channel directory
					 bell: (PolyphemusAgent semaphoreAt: self semaphoreIndex)) ].
	ring := [
	        reader whileStopped: [
		        (SpurWritableProcess on: reader) countOneSignalOnExternalSemaphore:
			        self semaphoreIndex ] ].
	channel ringing: ring.
	ring value.
	previous := process.
	process := HeldProcess
		           on: channel
		           reader: reader
		           identityHash: aHash
		           startingAt: aMethodSourceOrNil.
	"What the last hold read stays good for this one when nothing moved: as a step, not whole (#114)."
	previous ifNotNil: [ process takeTheReadingOf: previous ]
