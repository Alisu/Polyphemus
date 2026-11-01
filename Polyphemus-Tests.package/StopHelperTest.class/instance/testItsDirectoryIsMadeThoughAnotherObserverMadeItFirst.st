tests
testItsDirectoryIsMadeThoughAnotherObserverMadeItFirst

	"Observers started at once make the helpers' directory side by side: the one that loses the
	race gets DirectoryExists, which is no error (#72, seen on CI)."

	| made |
	made := DirectoryLosingARaceOnce new.

	StopHelper madeAt: made.

	self assert: made exists
