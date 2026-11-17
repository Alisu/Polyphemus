helpers
modeOf: aFile

	"As ls shows it, its first ten characters."

	^ (LibC resultOfCommand: 'ls -ld ''' , aFile fullName , '''') first: 10
