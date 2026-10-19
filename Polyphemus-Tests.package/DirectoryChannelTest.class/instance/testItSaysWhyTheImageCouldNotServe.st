tests
testItSaysWhyTheImageCouldNotServe

	"The watcher's do.st failed, which do-failed beside the channel says, with what went wrong:
	the observer's timeout says it too, not only that nobody answered (#90)."

	agent terminate.
	directory ensureDeleteAll.
	directory parent / 'do-failed' writeStreamDo: [ :stream | stream nextPutAll: 'FileWriteError: cannot create serving' ].
	[
	self
		should: [ channel ask: '3 + 4' within: 200 milliSeconds ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'FileWriteError: cannot create serving') ] ]
		ensure: [ (directory parent / 'do-failed') ensureDelete ]
