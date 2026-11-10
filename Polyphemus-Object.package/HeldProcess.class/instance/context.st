where
context

	"The context the image's own debugger is at, as memory shows it: the top one, or lower when
	it opened on a method below a trap's frames."

	^ self contexts at: self depthOfTheDebuggersContext + 1
