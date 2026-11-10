where
context

	"The context the image's own debugger is at, as memory shows it: the top one, or lower when
	it opened on a method below a trap's frames."

	| depth |
	"The depth first: asking the image allocates, and the reading is to be the last thing before
	an edit (#168)."
	depth := self depthOfTheDebuggersContext.
	^ self contexts at: depth + 1
