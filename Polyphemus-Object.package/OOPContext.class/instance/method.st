context protocol
method

	"The code this context runs. A block activation runs a compiled block; the
	debugger wants something that can answer source, so give it the home method."

	^ self homeMethod
