where
context

	"The context the image's own debugger is at, as memory shows it: the top one, or lower when
	it opened on a method below a trap's frames."

	| depth |
	depth := (channel ask: '| context depth |
context := (self at: #process) suspendedContext.
depth := 0.
[ context == (self at: #session) interruptedContext ] whileFalse: [
	context := context sender.
	depth := depth + 1 ].
depth') asNumber.
	^ self contexts at: depth + 1
