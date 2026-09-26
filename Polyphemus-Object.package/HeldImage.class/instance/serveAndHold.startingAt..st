private
serveAndHold: aHash startingAt: aMethodSourceOrNil

	"With the watcher holding: hand it an agent on a fresh channel, let it serve, and put that
	process in the image's own debugger. The agent's bell is the word that released the hold."

	| channel ring |
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
	process := HeldProcess
		           on: channel
		           reader: reader
		           identityHash: aHash
		           startingAt: aMethodSourceOrNil
