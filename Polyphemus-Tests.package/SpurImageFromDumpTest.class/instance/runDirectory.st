helpers
runDirectory

	"A directory of its own for the image a machine runs, so that a crash report found there
	is this test's and no other's."

	^ (PolyphemusEdition current scratch / 'polyphemus-from-dump-run') ensureCreateDirectory
