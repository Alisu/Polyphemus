testing
isAboutUIProcess

	"Never: the process debugged is the other image's, or none. Asked on close with no process,
	Pharo answered true when this image had no UI process either (nil = nil), and terminated the
	process that closed the window (#89)."

	^ false
