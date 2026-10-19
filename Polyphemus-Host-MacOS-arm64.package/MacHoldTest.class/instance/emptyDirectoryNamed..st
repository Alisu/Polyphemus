helpers
emptyDirectoryNamed: aName

	"A directory of the scratch, empty: what the watcher and the target leave behind, the
	observee's own under sudo, as a user would make it (#90)."

	| dir |
	dir := PolyphemusEdition current scratch / aName.
	dir ensureDeleteAll.
	dir ensureCreateDirectory.
	^ self giveToTheObservee: dir
