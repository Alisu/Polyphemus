tools
defaultHoldDirectoryFor: aPid

	"Where a watcher is put when hold is given no directory: made for the user the process runs
	as, and closed to others. The held image evaluates the do.st it finds there: a directory open
	to others, or another user's, is refused (#180)."

	| owner parent |
	OSPlatform current isWindows ifTrue: [ ^ FileLocator temp / 'polyphemus-hold' / aPid printString ].
	owner := (LibC resultOfCommand: 'ps -o uid= -p ' , aPid printString) trimBoth.
	owner ifEmpty: [ ^ ToolCallFailed signal: 'No process ' , aPid printString ].
	parent := (FileLocator temp / ('polyphemus-hold-' , owner)) asFileReference.
	{ parent. (parent / aPid printString) } do: [ :each |
		| listing |
		each exists ifFalse: [
			each ensureCreateDirectory.
			LibC system: 'chown ' , owner , ' "' , each fullName , '" 2>/dev/null; chmod 700 "' , each fullName , '"' ].
		listing := (LibC resultOfCommand: 'ls -ldn "' , each fullName , '"') substrings.
		(listing size >= 3 and: [ (listing first first: 10) = 'drwx------' and: [ (listing at: 3) = owner ] ]) ifFalse: [
			^ ToolCallFailed signal: each fullName , ' is not a directory of user ' , owner
				  , ' closed to others: give hold a directory of that user''s own' ] ].
	^ parent / aPid printString
