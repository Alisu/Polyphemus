private
serveAndHold: aHash startingAt: aMethodSourceOrNil

	"With the watcher holding: hand it an agent on a fresh channel, let it serve, and put that
	process in the image's own debugger."

	| channel |
	channel := DirectoryChannel on: directory / 'channel'.
	channel directory ensureDeleteAll.
	(directory / 'do.st')
		ensureDelete;
		writeStreamDo: [ :stream |
			stream nextPutAll: (PolyphemusAgent sourceServing: channel directory) ].
	reader whileStopped: [
		reader
			storeWord: 1 * 8 + 1
			at: (SpurDumpedMemory on: reader) raw addressOfTheInterruptSemaphoresExcessSignals ].
	process := HeldProcess
		           on: channel
		           reader: reader
		           identityHash: aHash
		           startingAt: aMethodSourceOrNil
