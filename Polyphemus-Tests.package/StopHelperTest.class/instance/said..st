helpers
said: aName

	"What the helper says in that state file, empty before: read as StopHelper reads it, a file
	renamed into place as it is opened being raised by Pharo as another error than a missing one."

	^ (StopHelper linesIn: directory / aName) ifEmpty: [ '' ] ifNotEmpty: [ :lines | lines first trimBoth ]
