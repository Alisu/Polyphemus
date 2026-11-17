tests
testItsDirectoryKeepsEachUsersFilesTheirOwn

	"#179: the directory is open to every user's observers, as /tmp is: sticky, so that a user
	cannot take away or replace the lock, the mark or the state of another's."

	| stop |
	stop := StopHelper on: target in: directory.
	self assert: stop start.
	self assert: stop end.
	self assert: (self modeOf: directory) equals: 'drwxrwxrwt'
