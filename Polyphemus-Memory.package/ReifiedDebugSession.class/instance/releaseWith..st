accessing
releaseWith: aBlock

	"What to do when the debugger is proceeded: let go of the image that was held for us.
	Without one, proceeding only closes the window."

	release := aBlock
