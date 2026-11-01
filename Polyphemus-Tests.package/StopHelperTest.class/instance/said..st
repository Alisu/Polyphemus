helpers
said: aName

	"What the helper says in that state file, empty before."

	^ [ (directory / aName) contents lines ifEmpty: [ '' ] ifNotEmpty: [ :lines | lines first trimBoth ] ]
		  on: FileDoesNotExistException
		  do: [ :error | '' ]
