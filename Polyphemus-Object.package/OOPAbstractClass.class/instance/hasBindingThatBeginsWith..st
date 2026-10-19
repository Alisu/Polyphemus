debugger protocol
hasBindingThatBeginsWith: aString

	"Whether a variable begins so, as Pharo 10's code pane asks while it colours (#89): this
	image's Object's answer, as for syntaxHighlighter."

	^ Object hasBindingThatBeginsWith: aString
