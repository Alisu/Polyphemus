private
serveAndHold: aHash startingAt: aMethodSourceOrNil

	"With the watcher holding: hand it an agent on a fresh channel, let it serve, and put that
	process in the image's own debugger. The agent's bell is the word that released the hold."

	| channel signals |
	channel := DirectoryChannel on: directory / 'channel'.
	channel directory ensureDeleteAll.
	(directory / 'do.st')
		ensureDelete;
		writeStreamDo: [ :stream |
			stream nextPutAll: (PolyphemusAgent sourceServing: channel directory) ].
	signals := reader whileStopped: [
		           (SpurDumpedMemory on: reader) raw addressOfTheInterruptSemaphoresExcessSignals ].
	channel ringing: [ reader whileStopped: [ reader storeWord: 1 * 8 + 1 at: signals ] ].
	reader whileStopped: [ reader storeWord: 1 * 8 + 1 at: signals ].
	process := HeldProcess
		           on: channel
		           reader: reader
		           identityHash: aHash
		           startingAt: aMethodSourceOrNil
