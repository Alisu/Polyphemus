accessing
said

	"What the helper last wrote in its state file, empty before."

	^ [ state contents trimBoth ] on: FileDoesNotExistException do: [ :error | '' ]
