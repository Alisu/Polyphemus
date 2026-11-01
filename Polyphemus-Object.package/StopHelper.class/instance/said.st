accessing
said

	"What the helper last wrote in its state file, empty before."

	^ (self class linesIn: state) ifEmpty: [ '' ] ifNotEmpty: [ :lines | lines first trimBoth ]
