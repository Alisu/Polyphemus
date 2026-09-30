directories
ensureDirectory: aDirectory

	"Made until it is there: runs make the directories they share side by side, and the one
	that loses the race, on it or on a parent, gets DirectoryExists (#72)."

	[ aDirectory exists ] whileFalse: [
		[ aDirectory ensureCreateDirectory ] on: DirectoryExists do: [ :e | ] ].
	^ aDirectory
