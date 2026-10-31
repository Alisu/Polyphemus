private
serveAndHold: aHash startingAt: aMethodSourceOrNil

	"With the watcher holding: hand it an agent on a fresh channel, let it serve, and put that
	process in the image's own debugger, read on from the last hold's reading when there was one.
	A failure there lets the image go."

	| channel previous |
	channel := DirectoryChannel on: directory / 'channel'.
	channel directory ensureDeleteAll.
	(directory / 'do.st.tmp')
		ensureDelete;
		writeStreamDo: [ :stream |
			stream nextPutAll: (PolyphemusAgent sourceServingOnItsOwnBell: channel directory) ].
	(directory / 'do.st.tmp') renameTo: 'do.st'.
	channel
		ringing: [ self ring ];
		whyGone: [ reader hasEnded ifTrue: [ 'its process ' , reader pid printString , ' ended' ] ].
	self ring.
	previous := process.
	[
	process := HeldProcess
		           on: channel
		           reader: reader
		           identityHash: aHash
		           startingAt: aMethodSourceOrNil.
	"What the last hold read stays good for this one when nothing moved: as a step, not whole (#114)."
	previous ifNotNil: [ process takeTheReadingOf: previous ] ]
		on: Error
		do: [ :error |
			self abandon: channel.
			error pass ]
