helpers
lockOwnedBy: aPid

	"A lock as an observer of that pid leaves it."

	(directory / 'hold.lock') ensureCreateDirectory.
	(directory / 'hold.lock' / 'owner') writeStreamDo: [ :stream | stream print: aPid ]
