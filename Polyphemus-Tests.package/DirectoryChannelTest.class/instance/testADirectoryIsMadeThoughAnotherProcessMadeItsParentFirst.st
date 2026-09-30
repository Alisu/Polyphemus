tests
testADirectoryIsMadeThoughAnotherProcessMadeItsParentFirst

	"Runs share their directories, and create them side by side: losing that race is no error,
	and the directory still ends up made (#72)."

	| directory |
	directory := DirectoryLosingARaceOnce new.

	PolyphemusEdition ensureDirectory: directory.

	self assert: directory exists.
	self assert: directory attempts equals: 2
