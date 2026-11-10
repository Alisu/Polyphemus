semaphore index
leaveSemaphoreIndex: anIndex in: aDirectory

	"Under another name first, then renamed: a reader finds it whole or not at all, never half
	written (#163). Pharo renames onto no file, so the old one goes just before."

	| file |
	file := aDirectory / 'semaphore-index.tmp'.
	file ensureDelete.
	file writeStreamDo: [ :stream | stream print: anIndex ].
	(aDirectory / 'semaphore-index') ensureDelete.
	file renameTo: 'semaphore-index'
