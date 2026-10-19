debugger protocol
syntaxHighlighter

	"What colours this class's methods in Pharo's code panes (#89): this image's Object's, as the
	class is the other image's; its variables show as unknown, which they are here."

	^ SHRBTextStyler new
		  classOrMetaClass: Object;
		  yourself
