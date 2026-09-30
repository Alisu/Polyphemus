creating
ensureCreateDirectory

	"The first time, another process has just created a parent: nothing made here."

	attempts := self attempts + 1.
	attempts = 1 ifTrue: [ ^ DirectoryExists signalWith: Path / 'tmp' ].
	created := true
