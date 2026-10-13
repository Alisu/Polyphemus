helpers
emptyDirectoryNamed: aName

	"A directory of the scratch, empty: what the watcher and the target leave behind."

	| dir |
	dir := PolyphemusEdition current scratch / aName.
	dir ensureDeleteAll.
	dir ensureCreateDirectory.
	^ dir
